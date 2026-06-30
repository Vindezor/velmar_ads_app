# Funciones de la Base de Datos (Supabase) - Velmar Ads

Este archivo contiene la documentación y definición SQL de las funciones (Stored Procedures) disponibles en la base de datos de Supabase para el proyecto Velmar Ads.

---

## 1. `approve_credit_request`
*   **Esquema:** `public`
*   **Argumentos:** `p_request_id uuid, p_admin_id uuid, p_notes text DEFAULT NULL::text`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.approve_credit_request(p_request_id uuid, p_admin_id uuid, p_notes text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_request credit_requests%rowtype;
  v_new_balance decimal;
begin
  if not exists (select 1 from profiles where id = p_admin_id and role = 'admin') then
    return jsonb_build_object('success', false, 'error', 'No tienes permisos de administrador');
  end if;

  select * into v_request from credit_requests where id = p_request_id;

  if v_request.id is null then
    return jsonb_build_object('success', false, 'error', 'Solicitud no encontrada');
  end if;

  if v_request.status != 'pending' then
    return jsonb_build_object('success', false, 'error', 'Esta solicitud ya fue procesada');
  end if;

  -- Actualizar solicitud
  update credit_requests set
    status = 'approved',
    reviewed_by = p_admin_id,
    reviewed_at = now(),
    admin_notes = p_notes,
    updated_at = now()
  where id = p_request_id;

  -- Acreditar créditos al usuario
  update profiles
  set credits = credits + v_request.credits_requested,
      updated_at = now()
  where id = v_request.user_id
  returning credits into v_new_balance;

  -- Registrar en ledger
  insert into credit_ledger (user_id, amount, balance_after, type, reference_id, description)
  values (
    v_request.user_id,
    v_request.credits_requested,
    v_new_balance,
    'credit_purchase',
    p_request_id,
    'Carga de créditos aprobada. Orden: ' || v_request.order_number
  );

  return jsonb_build_object(
    'success', true,
    'credits_added', v_request.credits_requested,
    'new_balance', v_new_balance,
    'order_number', v_request.order_number
  );
end;
$function$
```

---

## 2. `calculate_booking_price`
*   **Esquema:** `public`
*   **Argumentos:** `p_billboard_id uuid, p_booking_type_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.calculate_booking_price(p_billboard_id uuid, p_booking_type_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
  v_zone_base_price     decimal;
  v_size_multiplier     decimal;
  v_booking_multiplier  decimal;
  v_hour_multiplier     decimal;
  v_total               decimal := 0;
  v_current             timestamptz := p_start_time;
  v_zone_id             uuid;
  v_size_cat_id         uuid;
  v_screen_class_name   text;
  v_screen_class_label  text;
  v_unit_symbol         text;
  v_size_value          decimal;
  v_hour_of_day         int;
begin
  select
    b.zone_id,
    b.size_category_id,
    sc.name,
    sc.label,
    mu.symbol,
    b.size_value
  into
    v_zone_id,
    v_size_cat_id,
    v_screen_class_name,
    v_screen_class_label,
    v_unit_symbol,
    v_size_value
  from billboards b
  left join screen_classes sc    on sc.id = b.screen_class_id
  left join measurement_units mu on mu.id = b.unit_id
  where b.id = p_billboard_id;

  select base_price_per_hour into v_zone_base_price
  from zones where id = v_zone_id;

  select price_multiplier into v_size_multiplier
  from size_categories where id = v_size_cat_id;

  select discount_multiplier into v_booking_multiplier
  from booking_types where id = p_booking_type_id;

  while v_current < p_end_time loop
    v_hour_of_day := extract(hour from v_current at time zone 'America/Caracas');

    select price_multiplier into v_hour_multiplier
    from zone_pricing_slots
    where zone_id = v_zone_id
      and hour_start <= v_hour_of_day
      and hour_end > v_hour_of_day
      and is_active = true
    limit 1;

    v_total := v_total + (
      coalesce(v_zone_base_price, 0)
      * coalesce(v_size_multiplier, 1.0)
      * coalesce(v_hour_multiplier, 1.0)
      * coalesce(v_booking_multiplier, 1.0)
    );

    v_current := v_current + interval '1 hour';
  end loop;

  return jsonb_build_object(
    'total',               v_total,
    'base_price_per_hour', v_zone_base_price,
    'size_multiplier',     v_size_multiplier,
    'booking_multiplier',  v_booking_multiplier,
    'screen_class',        v_screen_class_name,
    'screen_class_label',  v_screen_class_label,
    'size_value',          v_size_value,
    'unit_symbol',         v_unit_symbol,
    'hours',               extract(epoch from (p_end_time - p_start_time)) / 3600
  );
end;
$function$
```

---

## 3. `check_billboard_availability`
*   **Esquema:** `public`
*   **Argumentos:** `p_billboard_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone, p_exclude_booking_id uuid DEFAULT NULL::uuid`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.check_billboard_availability(p_billboard_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone, p_exclude_booking_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
  v_max_ads int;
  v_slot_count int;
  v_current timestamptz := p_start_time;
  v_max_in_any_hour int := 0;
  v_count int;
begin
  -- Obtener límite global de anuncios simultáneos
  select value::int into v_max_ads from app_config where key = 'max_ads_per_slot';

  -- Verificar hora por hora
  while v_current < p_end_time loop
    select count(*) into v_count
    from bookings
    where billboard_id = p_billboard_id
      and status in ('pending', 'approved', 'resubmitted')
      and (p_exclude_booking_id is null or id != p_exclude_booking_id)
      and start_time < (v_current + interval '1 hour')
      and end_time > v_current;

    if v_count > v_max_in_any_hour then
      v_max_in_any_hour := v_count;
    end if;

    v_current := v_current + interval '1 hour';
  end loop;

  return jsonb_build_object(
    'available',        v_max_in_any_hour < v_max_ads,
    'slots_used',       v_max_in_any_hour,
    'slots_max',        v_max_ads,
    'slots_remaining',  v_max_ads - v_max_in_any_hour
  );
end;
$function$
```

---

## 4. `create_booking`
*   **Esquema:** `public`
*   **Argumentos:** `p_user_id uuid, p_billboard_id uuid, p_booking_type_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone, p_asset_id uuid`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.create_booking(p_user_id uuid, p_billboard_id uuid, p_booking_type_id uuid, p_start_time timestamp with time zone, p_end_time timestamp with time zone, p_asset_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_moderation_hours int;
  v_min_start timestamptz;
  v_availability jsonb;
  v_price_data jsonb;
  v_user_credits decimal;
  v_booking_id uuid;
  v_mod_deadline timestamptz;
  v_asset creative_assets%rowtype;
  v_initial_status text;
begin
  -- Verificar que el asset existe y pertenece al usuario
  select * into v_asset from creative_assets
  where id = p_asset_id and user_id = p_user_id;

  if v_asset.id is null then
    return jsonb_build_object('success', false, 'error', 'Archivo no encontrado o no te pertenece');
  end if;

  if v_asset.status = 'rejected' then
    return jsonb_build_object('success', false, 'error', 'Este archivo fue rechazado y no puede usarse para reservas');
  end if;

  -- Obtener ventana de moderación desde config
  select value::int into v_moderation_hours from app_config where key = 'moderation_window_hours';
  v_min_start := now() + (v_moderation_hours || ' hours')::interval;

  -- Si el asset ya está aprobado, no necesita ventana de moderación
  if v_asset.status != 'approved' and p_start_time < v_min_start then
    return jsonb_build_object(
      'success', false,
      'error', 'Debes reservar al menos ' || v_moderation_hours || ' horas antes del inicio para permitir la moderación. O usa un archivo ya aprobado para reservar sin restricción de tiempo.'
    );
  end if;

  if p_end_time <= p_start_time then
    return jsonb_build_object('success', false, 'error', 'La hora de fin debe ser posterior a la hora de inicio');
  end if;

  -- Verificar disponibilidad
  v_availability := check_billboard_availability(p_billboard_id, p_start_time, p_end_time);
  if not (v_availability->>'available')::boolean then
    return jsonb_build_object(
      'success', false,
      'error', 'No hay espacio disponible en ese horario. Slots usados: ' ||
               (v_availability->>'slots_used') || ' de ' || (v_availability->>'slots_max')
    );
  end if;

  -- Calcular precio
  v_price_data := calculate_booking_price(p_billboard_id, p_booking_type_id, p_start_time, p_end_time);

  -- Verificar créditos suficientes
  select credits into v_user_credits from profiles where id = p_user_id;
  if v_user_credits < (v_price_data->>'total')::decimal then
    return jsonb_build_object(
      'success', false,
      'error', 'Créditos insuficientes. Tienes ' || v_user_credits || ' créditos, necesitas ' || (v_price_data->>'total')
    );
  end if;

  -- Determinar estado inicial según si el asset ya está aprobado
  if v_asset.status = 'approved' then
    v_initial_status := 'approved';      -- salta moderación
    v_mod_deadline := null;
  else
    v_initial_status := 'pending';       -- moderación normal
    v_mod_deadline := now() + (v_moderation_hours || ' hours')::interval;
  end if;

  -- Crear la reserva
  insert into bookings (
    user_id, billboard_id, booking_type_id,
    start_time, end_time,
    asset_id,
    price_snapshot, total_credits,
    status, moderation_deadline,
    -- Si asset aprobado, marcar como auto-aprobado
    approved_at, moderated_at
  )
  values (
    p_user_id, p_billboard_id, p_booking_type_id,
    p_start_time, p_end_time,
    p_asset_id,
    v_price_data, (v_price_data->>'total')::decimal,
    v_initial_status, v_mod_deadline,
    case when v_asset.status = 'approved' then now() else null end,
    case when v_asset.status = 'approved' then now() else null end
  )
  returning id into v_booking_id;

  -- Descontar créditos
  update profiles
  set credits = credits - (v_price_data->>'total')::decimal,
      updated_at = now()
  where id = p_user_id;

  -- Registrar en ledger
  insert into credit_ledger (user_id, amount, balance_after, type, reference_id, description)
  values (
    p_user_id,
    -(v_price_data->>'total')::decimal,
    v_user_credits - (v_price_data->>'total')::decimal,
    'booking_payment',
    v_booking_id,
    'Pago de reserva en pantalla'
  );

  -- Actualizar contador de uso del asset
  update creative_assets
  set times_used = times_used + 1,
      last_used_at = now(),
      updated_at = now()
  where id = p_asset_id;

  return jsonb_build_object(
    'success',          true,
    'booking_id',       v_booking_id,
    'status',           v_initial_status,
    'auto_approved',    v_asset.status = 'approved',
    'total_credits',    v_price_data->>'total',
    'price_breakdown',  v_price_data,
    'slots_remaining',  (v_availability->>'slots_remaining')::int - 1
  );
end;
$function$
```

---

## 5. `expire_overdue_bookings`
*   **Esquema:** `public`
*   **Argumentos:** *Ninguno*
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.expire_overdue_bookings()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_expired_count int := 0;
  v_booking bookings%rowtype;
  v_new_balance decimal;
begin
  for v_booking in
    select * from bookings
    where status = 'rejected'
      and correction_deadline < now()
      and credits_refunded = false
  loop
    -- Liberar horas y devolver créditos
    update bookings set
      status = 'expired',
      credits_refunded = true,
      updated_at = now()
    where id = v_booking.id;

    -- Devolver créditos al usuario
    update profiles
    set credits = credits + v_booking.total_credits,
        updated_at = now()
    where id = v_booking.user_id
    returning credits into v_new_balance;

    -- Registrar en ledger
    insert into credit_ledger (user_id, amount, balance_after, type, reference_id, description)
    values (
      v_booking.user_id,
      v_booking.total_credits,
      v_new_balance,
      'refund_rejection',
      v_booking.id,
      'Reembolso por anuncio rechazado no corregido a tiempo'
    );

    v_expired_count := v_expired_count + 1;
  end loop;

  return jsonb_build_object('expired', v_expired_count, 'timestamp', now());
end;
$function$
```

---

## 6. `generate_order_number`
*   **Esquema:** `public`
*   **Argumentos:** *Trigger (NEW)*
*   **Retorna:** `trigger`

```sql
CREATE OR REPLACE FUNCTION public.generate_order_number()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.order_number := 'CR-' || to_char(now(), 'YYYYMMDD') || '-' || lpad(nextval('credit_order_seq')::text, 5, '0');
  return new;
end;
$function$
```

---

## 7. `handle_new_user`
*   **Esquema:** `public`
*   **Argumentos:** *Trigger (NEW)*
*   **Retorna:** `trigger`

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  INSERT INTO public.profiles (id, full_name, role, credits, created_at, updated_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuario'),
    'client',
    0,
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$function$
```

---

## 8. `is_admin`
*   **Esquema:** `public`
*   **Argumentos:** *Ninguno*
*   **Retorna:** `boolean`

```sql
CREATE OR REPLACE FUNCTION public.is_admin()
 RETURNS boolean
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$function$
```

---

## 9. `moderate_booking`
*   **Esquema:** `public`
*   **Argumentos:** `p_booking_id uuid, p_admin_id uuid, p_action text, p_notes text DEFAULT NULL::text`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.moderate_booking(p_booking_id uuid, p_admin_id uuid, p_action text, p_notes text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_booking bookings%rowtype;
  v_correction_hours int;
begin
  if not exists (select 1 from profiles where id = p_admin_id and role = 'admin') then
    return jsonb_build_object('success', false, 'error', 'No tienes permisos de administrador');
  end if;

  select * into v_booking from bookings where id = p_booking_id;

  if v_booking.id is null then
    return jsonb_build_object('success', false, 'error', 'Reserva no encontrada');
  end if;

  if v_booking.status not in ('pending', 'resubmitted') then
    return jsonb_build_object('success', false, 'error', 'Esta reserva no está pendiente de moderación');
  end if;

  if p_action = 'approve' then
    -- Aprobar reserva
    update bookings set
      status = 'approved',
      moderated_at = now(),
      approved_at = now(),
      moderated_by = p_admin_id,
      moderation_notes = p_notes,
      updated_at = now()
    where id = p_booking_id;

    -- Aprobar el asset también (queda disponible para reutilización)
    update creative_assets set
      status = 'approved',
      moderated_by = p_admin_id,
      moderated_at = now(),
      moderation_notes = p_notes,
      updated_at = now()
    where id = v_booking.asset_id
      and status = 'pending';              -- solo si aún no estaba aprobado

  elsif p_action = 'reject' then
    select value::int into v_correction_hours from app_config where key = 'correction_window_hours';

    -- Rechazar reserva
    update bookings set
      status = 'rejected',
      moderated_at = now(),
      moderated_by = p_admin_id,
      moderation_notes = p_notes,
      correction_deadline = now() + (v_correction_hours || ' hours')::interval,
      resubmission_count = resubmission_count + 1,
      updated_at = now()
    where id = p_booking_id;

    -- Rechazar el asset
    update creative_assets set
      status = 'rejected',
      moderated_by = p_admin_id,
      moderated_at = now(),
      moderation_notes = p_notes,
      updated_at = now()
    where id = v_booking.asset_id;

  else
    return jsonb_build_object('success', false, 'error', 'Acción inválida. Usa "approve" o "reject"');
  end if;

  return jsonb_build_object('success', true, 'action', p_action, 'booking_id', p_booking_id);
end;
$function$
```

---

## 10. `reject_credit_request`
*   **Esquema:** `public`
*   **Argumentos:** `p_request_id uuid, p_admin_id uuid, p_notes text`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.reject_credit_request(p_request_id uuid, p_admin_id uuid, p_notes text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  if not exists (select 1 from profiles where id = p_admin_id and role = 'admin') then
    return jsonb_build_object('success', false, 'error', 'No tienes permisos de administrador');
  end if;

  update credit_requests set
    status = 'rejected',
    reviewed_by = p_admin_id,
    reviewed_at = now(),
    admin_notes = p_notes,
    updated_at = now()
  where id = p_request_id and status = 'pending';

  if not found then
    return jsonb_build_object('success', false, 'error', 'Solicitud no encontrada o ya procesada');
  end if;

  return jsonb_build_object('success', true);
end;
$function$
```

---

## 11. `resubmit_booking` (Con asset ID)
*   **Esquema:** `public`
*   **Argumentos:** `p_booking_id uuid, p_user_id uuid, p_new_asset_id uuid`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.resubmit_booking(p_booking_id uuid, p_user_id uuid, p_new_asset_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_booking bookings%rowtype;
  v_asset creative_assets%rowtype;
begin
  select * into v_booking from bookings
  where id = p_booking_id and user_id = p_user_id;

  if v_booking.id is null then
    return jsonb_build_object('success', false, 'error', 'Reserva no encontrada');
  end if;

  if v_booking.status != 'rejected' then
    return jsonb_build_object('success', false, 'error', 'Solo puedes corregir reservas rechazadas');
  end if;

  if now() > v_booking.correction_deadline then
    return jsonb_build_object('success', false, 'error', 'El plazo de corrección venció');
  end if;

  -- Verificar el nuevo asset
  select * into v_asset from creative_assets
  where id = p_new_asset_id and user_id = p_user_id;

  if v_asset.id is null then
    return jsonb_build_object('success', false, 'error', 'Archivo no encontrado o no te pertenece');
  end if;

  if v_asset.status = 'rejected' then
    return jsonb_build_object('success', false, 'error', 'Este archivo fue rechazado y no puede usarse');
  end if;

  -- Si el nuevo asset ya está aprobado → reserva va directo a approved
  if v_asset.status = 'approved' then
    update bookings set
      status = 'approved',
      asset_id = p_new_asset_id,
      approved_at = now(),
      moderated_at = now(),
      moderated_by = null,
      updated_at = now()
    where id = p_booking_id;

    update creative_assets
    set times_used = times_used + 1, last_used_at = now(), updated_at = now()
    where id = p_new_asset_id;

    return jsonb_build_object('success', true, 'status', 'approved', 'auto_approved', true);
  end if;

  -- Si es un asset nuevo (pending) → vuelve a moderación
  update bookings set
    status = 'resubmitted',
    asset_id = p_new_asset_id,
    moderated_at = null,
    moderated_by = null,
    updated_at = now()
  where id = p_booking_id;

  update creative_assets
  set times_used = times_used + 1, last_used_at = now(), updated_at = now()
  where id = p_new_asset_id;

  return jsonb_build_object('success', true, 'status', 'resubmitted', 'auto_approved', false);
end;
$function$
```

---

## 12. `resubmit_booking` (Con URL y Tipo)
*   **Esquema:** `public`
*   **Argumentos:** `p_booking_id uuid, p_user_id uuid, p_new_file_url text, p_new_file_type text`
*   **Retorna:** `jsonb`

```sql
CREATE OR REPLACE FUNCTION public.resubmit_booking(p_booking_id uuid, p_user_id uuid, p_new_file_url text, p_new_file_type text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_booking bookings%rowtype;
begin
  select * into v_booking from bookings
  where id = p_booking_id and user_id = p_user_id;

  if v_booking.id is null then
    return jsonb_build_object('success', false, 'error', 'Reserva no encontrada');
  end if;

  if v_booking.status != 'rejected' then
    return jsonb_build_object('success', false, 'error', 'Solo puedes corregir anuncios rechazados');
  end if;

  if now() > v_booking.correction_deadline then
    return jsonb_build_object('success', false, 'error', 'El plazo de corrección venció. Las horas fueron liberadas.');
  end if;

  update bookings set
    status = 'resubmitted',
    file_url = p_new_file_url,
    file_type = p_new_file_type,
    moderated_at = null,
    moderated_by = null,
    updated_at = now()
  where id = p_booking_id;

  return jsonb_build_object('success', true, 'message', 'Anuncio enviado a moderación nuevamente');
end;
$function$
```

---

## 13. `rls_auto_enable`
*   **Esquema:** `public`
*   **Argumentos:** *Ninguno*
*   **Retorna:** `event_trigger`

```sql
CREATE OR REPLACE FUNCTION public.rls_auto_enable()
 RETURNS event_trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$
```

