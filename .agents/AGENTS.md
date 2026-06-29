# Reglas del Agente para Velmar Ads

Este archivo contiene pautas de comportamiento y codificación obligatorias para este proyecto. Cualquier agente de IA que trabaje en esta base de código debe seguir estas reglas para garantizar la consistencia de la arquitectura.

---

## 🏗️ Arquitectura y Estructura del Código

Este proyecto utiliza **Clean Architecture** (Arquitectura Limpia) con **Flutter BLoC** para la gestión de estados y **Supabase** como backend.

### 📜 Documentación de Referencia
*   Consulta el archivo [ARCHITECTURE.md](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/ARCHITECTURE.md) en la raíz del proyecto para una explicación detallada de todas las capas (`domain`, `data`, `presentation`), enrutamiento e inyección de dependencias.

---

## 🛠️ Reglas Obligatorias de Programación

1.  **Estructura de Carpetas de Características (`features/`)**:
    *   Al crear una nueva característica, siempre divídela en `domain`, `data` y `presentation` con sus respectivas subcarpetas.
    *   No mezcles lógica de datos (ej. cliente de Supabase, serialización JSON) en la capa de UI o dominio.
    *   **Prohibición de Importaciones Cruzadas en Capa de Datos**: Queda estrictamente prohibido que una característica importación directa de componentes de la capa de datos (`Models`, `DataSources`, `RepositoriesImpl`) de otra característica. Para compartir información de usuario, usa las entidades y cubits globales provistos en `core` (ej: `User` y `AppUserCubit` en `lib/core/common/`).
    *   **No Modificar Características Existentes por Requerimientos de Nuevas Características**: Queda terminantemente prohibido modificar modelos, data sources, entidades o repositorios de una característica ya implementada (como `auth`) solo para satisfacer las necesidades de datos de una característica nueva (como `dashboard`). Cada característica debe ser completamente autónoma y resolver sus consultas en su propio DataSource utilizando los identificadores compartidos de `core` (como el ID del usuario provisto por la sesión). No se debe acoplar o contaminar la lógica de otras características.



2.  **Manejo de Errores y Tipos Retornados**:
    *   Los Data Sources (`data/datasources/`) deben lanzar excepciones específicas (ej. `ServerException`).
    *   Los Repositorios (`data/repositories/`) deben implementar la interfaz definida en el dominio, atrapar las excepciones y retornar un `Either<Failure, T>` usando la librería `fpdart`.
    *   Los Casos de Uso (`domain/usecases/`) deben retornar siempre `Future<Either<Failure, T>>` y heredar de la clase base `UseCase`.

3.  **Inyección de Dependencias (DI)**:
    *   Registra siempre los nuevos componentes (Data Sources, Repositorios, Casos de Uso y Blocs) en [init_dependencies.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/init_dependencies.dart).
    *   Usa `registerFactory` para clases sin estado o que requieran instancias nuevas (UseCases, Repositories, Blocs).
    *   Usa `registerLazySingleton` para servicios persistentes y fuentes de datos que deban compartirse.

4.  **Gestión de Estados**:
    *   Usa `flutter_bloc`. Los Blocs se colocan en `presentation/bloc/` de su respectiva feature.
    *   Para estados compartidos globalmente (como autenticación e información básica del usuario activo), utiliza el cubit global `AppUserCubit` ubicado en `lib/core/common/cubits/app_user/`.
    *   **Encapsulamiento de Dependencias en Blocs**: Las dependencias inyectadas en los constructores de los Blocs/Cubits deben definirse como variables finales privadas (ej: `final GetDashboardData _getDashboardData;`) e inicializarse mediante la lista de inicialización del constructor (ej: `: _getDashboardData = getDashboardData`). Se debe usar el comentario `// ignore_for_file: prefer_initializing_formals` al inicio del archivo para silenciar la advertencia del analizador de Dart.
    *   **Un solo BLoC por Característica (Estandarización)**: Queda establecido que para mantener la uniformidad arquitectónica del proyecto, cada característica (feature) debe tener un único BLoC principal nombrado de forma idéntica a la característica (ej. `AuthBloc`, `DashboardBloc`, `BookingsBloc`, `LibraryBloc`). Los archivos correspondientes deben nombrarse como `feature_bloc.dart`, `feature_event.dart` y `feature_state.dart` dentro del directorio `presentation/bloc/`. Se prohíbe la creación de Cubits individuales o de múltiples sub-blocs dispersos que fraccionen el estado de la misma característica.


5.  **Enrutamiento (`go_router`)**:
    *   Registra las páginas en [app_router.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/router/app_router.dart).
    *   Todas las pantallas protegidas deben ser redirigidas automáticamente a `/login` si el estado de `AppUserCubit` indica que el usuario no está autenticado.

6.  **Traducción de Diseño e Integración UI**:
    *   Los diseños son provistos por un diseñador en formato **HTML/CSS**. El agente de IA debe trasladar estos diseños de forma fiel a la app de Flutter.
    *   Se deben usar **estrictamente** los recursos de Flutter Material alineados al sistema de diseño preestablecido en el código:
        *   Colores: Usa `AppPallete` en [app_pallete.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/theme/app_pallete.dart) o `Theme.of(context).colorScheme` definido en [theme.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/theme/theme.dart).
        *   Tipografías: Usa `AppTypography` o `Theme.of(context).textTheme`.
        *   Bordes y Radios: Usa los valores definidos en `AppRadius` (ej. `AppRadius.md`).
        *   Espaciados: Usa los espaciados estandarizados en `AppSpacing`.
    *   Queda prohibido hardcodear colores o dimensiones arbitrarias sin justificación.
    *   **Descomposición de Widgets (SRP y Mantenibilidad)**: Queda estrictamente prohibido construir o acumular lógica de sub-widgets mediante métodos o funciones auxiliares privadas (ej. `_buildAppBar()`, `_buildLoadedView()`, `_buildSubHeader()`) dentro de la clase principal de la página. Toda estructura de componentes de UI, incluso las más básicas como el AppBar o las vistas cargadas/errores, debe extraerse obligatoriamente a archivos separados dentro de la carpeta `widgets/` de la característica y estructurarse como clases independientes (`StatelessWidget` o `StatefulWidget`) para optimizar el ciclo de vida y reconstrucción de widgets de Flutter.
    *   **Extracción de Utilidades de Formato (SRP)**: Ninguna lógica de formato compleja (como formatear dinero, fechas o números) debe estar acoplada a las clases de la UI. Estas deben extraerse a clases de utilidad pura bajo `lib/core/utils/` (ej: `CurrencyFormatter`).
    *   **Manejo de Estados con Switch de Dart 3 (OCP)**: Al consumir estados de Blocs sellados (`sealed class`), utiliza expresiones `switch` de Dart 3 en lugar de cadenas de `if/else if`. Esto provee comprobación de exhaustividad en tiempo de compilación y garantiza que se cumpla el principio Abierto/Cerrado ante nuevos estados.
    *   **Integridad de Datos (No Inventar Datos)**: Queda estrictamente prohibido hardcodear o inventar valores de prueba/placeholders para especificaciones técnicas o de negocio que no provengan de la base de datos o la API. Si un campo no existe en las tablas de Supabase, debe eliminarse de la vista. Si el valor es opcional o nulo, debe mostrarse como 'N/A' o remover la fila correspondiente para garantizar la consistencia con el backend.
7.  **Principios SOLID y Coordinación de Estados (Cubit/Bloc)**:
    *   Sigue estrictamente los principios SOLID. Evita acoplar la UI con la lógica de sesión o negocio.
    *   Si un Bloc o Cubit de una funcionalidad específica (ej. `DashboardBloc`) necesita consultar la sesión o la información del usuario logueado, inyecta `AppUserCubit` en su constructor.
    *   Los eventos de carga de la UI no deben arrastrar parámetros que ya están disponibles en los estados globales (como el `userId`), delegando esa obtención de forma interna al Bloc mediante el Cubit inyectado.

8.  **Estrategia de Caché en Repositorios y Refresco Silencioso (Caché con TTL + Background Refresh)**:
    *   Los repositorios deben registrarse como singletons (`registerLazySingleton`) en [init_dependencies.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/init_dependencies.dart) para mantener la memoria caché viva.
    *   Las consultas a la base de datos deben almacenarse en caché con un tiempo de vida (TTL) de 60 segundos, segmentadas por `userId`.
    *   Los métodos de lectura en repositorios y sus correspondientes casos de uso deben aceptar un parámetro opcional `bool forceRefresh = false` para ignorar el caché cuando se requiera (como en pull-to-refresh).
    *   Las operaciones de escritura (ej: crear reservas, subir assets, solicitar créditos) deben invalidar de forma inmediata el caché local correspondiente en el repositorio.
    *   En los Blocs, para evitar la sobrecarga visual de cargando (pantallas con spinners de pantalla completa), solo se debe emitir el estado de `Loading` cuando no existan datos cargados previamente. Si los datos ya se encuentran en estado de éxito, la recarga se realiza en segundo plano (*background refresh*) y se actualizan silenciosamente de forma fluida.

---

## 💬 Estilo de Comunicación y Entregas

*   **Resumen de Cambios Estilo Git**: Al finalizar una tarea o refactorización que involucre cambios en el código, el agente debe incluir al final de su respuesta un bloque breve y conciso (en una sola línea) formateado con el estilo Git en inglés (ej: `Add: ... Fix: ... Modify: ...`). Este resumen debe explicar brevemente la funcionalidad que se arregló o agregó (por ejemplo, `Add: credit requests history page`), en lugar de enumerar individualmente los archivos o clases técnicas modificadas.

---

## 🗄️ Esquema de Base de Datos de Supabase

Ten en cuenta este esquema al crear modelos de datos, entidades y data sources:

```sql
-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.app_config (
  key text NOT NULL,
  value text NOT NULL,
  description text,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT app_config_pkey PRIMARY KEY (key)
);

CREATE TABLE public.profiles (
  id uuid NOT NULL,
  full_name text,
  phone text,
  role text DEFAULT 'client'::text CHECK (role = ANY (ARRAY['client'::text, 'admin'::text])),
  credits numeric DEFAULT 0 CHECK (credits >= 0::numeric),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);

CREATE TABLE public.cities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  country text NOT NULL DEFAULT 'Venezuela'::text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT cities_pkey PRIMARY KEY (id)
);

CREATE TABLE public.zones (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  city_id uuid,
  name text NOT NULL,
  base_price_per_hour numeric NOT NULL,
  description text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT zones_pkey PRIMARY KEY (id),
  CONSTRAINT zones_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id)
);

CREATE TABLE public.size_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  label text NOT NULL,
  min_size numeric,
  max_size numeric,
  price_multiplier numeric NOT NULL DEFAULT 1.000,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  screen_class_id uuid,
  unit_id uuid,
  CONSTRAINT size_categories_pkey PRIMARY KEY (id),
  CONSTRAINT size_categories_screen_class_id_fkey FOREIGN KEY (screen_class_id) REFERENCES public.screen_classes(id),
  CONSTRAINT size_categories_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.measurement_units(id)
);

CREATE TABLE public.zone_pricing_slots (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  zone_id uuid,
  label text NOT NULL,
  hour_start integer NOT NULL,
  hour_end integer NOT NULL,
  price_multiplier numeric NOT NULL DEFAULT 1.000,
  is_active boolean DEFAULT true,
  CONSTRAINT zone_pricing_slots_pkey PRIMARY KEY (id),
  CONSTRAINT zone_pricing_slots_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(id)
);

CREATE TABLE public.billboards (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  zone_id uuid,
  size_category_id uuid,
  name text NOT NULL,
  address text,
  lat double precision NOT NULL,
  lng double precision NOT NULL,
  width_m numeric,
  height_m numeric,
  sqm numeric DEFAULT (width_m * height_m),
  screen_type text CHECK (screen_type = ANY (ARRAY['LED'::text, 'LCD'::text, 'Estática'::text, 'Otro'::text])),
  resolution_w integer,
  resolution_h integer,
  accepted_formats ARRAY DEFAULT ARRAY['image/jpeg'::text, 'image/png'::text, 'video/mp4'::text],
  max_file_size_mb integer DEFAULT 50,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  screen_class_id uuid,
  unit_id uuid,
  size_value numeric,
  CONSTRAINT billboards_pkey PRIMARY KEY (id),
  CONSTRAINT billboards_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(id),
  CONSTRAINT billboards_size_category_id_fkey FOREIGN KEY (size_category_id) REFERENCES public.size_categories(id),
  CONSTRAINT billboards_screen_class_id_fkey FOREIGN KEY (screen_class_id) REFERENCES public.screen_classes(id),
  CONSTRAINT billboards_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.measurement_units(id)
);

CREATE TABLE public.booking_types (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  slot_duration_minutes integer NOT NULL DEFAULT 60,
  max_ads_per_slot integer NOT NULL DEFAULT 6,
  discount_multiplier numeric NOT NULL DEFAULT 1.000,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT booking_types_pkey PRIMARY KEY (id)
);

CREATE TABLE public.credit_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  order_number text NOT NULL UNIQUE,
  credits_requested numeric NOT NULL CHECK (credits_requested > 0::numeric),
  usd_amount numeric NOT NULL,
  payment_proof_url text,
  payment_notes text,
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])),
  admin_notes text,
  reviewed_by uuid,
  reviewed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT credit_requests_pkey PRIMARY KEY (id),
  CONSTRAINT credit_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT credit_requests_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES auth.users(id)
);

CREATE TABLE public.bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  billboard_id uuid,
  booking_type_id uuid,
  start_time timestamp with time zone NOT NULL,
  end_time timestamp with time zone NOT NULL,
  price_snapshot jsonb NOT NULL,
  total_credits numeric NOT NULL,
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'resubmitted'::text, 'expired'::text, 'cancelled'::text])),
  submitted_at timestamp with time zone DEFAULT now(),
  moderation_deadline timestamp with time zone,
  correction_deadline timestamp with time zone,
  moderated_at timestamp with time zone,
  approved_at timestamp with time zone,
  moderation_notes text,
  moderated_by uuid,
  credits_refunded boolean DEFAULT false,
  resubmission_count integer DEFAULT 0,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  asset_id uuid,
  CONSTRAINT bookings_pkey PRIMARY KEY (id),
  CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT bookings_billboard_id_fkey FOREIGN KEY (billboard_id) REFERENCES public.billboards(id),
  CONSTRAINT bookings_booking_type_id_fkey FOREIGN KEY (booking_type_id) REFERENCES public.booking_types(id),
  CONSTRAINT bookings_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES auth.users(id),
  CONSTRAINT bookings_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.creative_assets(id)
);

CREATE TABLE public.credit_ledger (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  amount numeric NOT NULL,
  balance_after numeric NOT NULL,
  type text NOT NULL CHECK (type = ANY (ARRAY['credit_purchase'::text, 'booking_payment'::text, 'refund_rejection'::text, 'refund_cancellation'::text, 'admin_adjustment'::text])),
  reference_id uuid,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT credit_ledger_pkey PRIMARY KEY (id),
  CONSTRAINT credit_ledger_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.screen_classes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  label text NOT NULL,
  description text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  default_unit_id uuid,
  CONSTRAINT screen_classes_pkey PRIMARY KEY (id),
  CONSTRAINT screen_classes_default_unit_id_fkey FOREIGN KEY (default_unit_id) REFERENCES public.measurement_units(id)
);

CREATE TABLE public.measurement_units (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  label text NOT NULL,
  symbol text NOT NULL,
  description text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT measurement_units_pkey PRIMARY KEY (id)
);

CREATE TABLE public.creative_assets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  file_url text NOT NULL,
  file_type text NOT NULL CHECK (file_type = ANY (ARRAY['image'::text, 'video'::text])),
  file_size_mb numeric,
  original_filename text,
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])),
  moderated_by uuid,
  moderated_at timestamp with time zone,
  moderation_notes text,
  times_used integer DEFAULT 0,
  last_used_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT creative_assets_pkey PRIMARY KEY (id),
  CONSTRAINT creative_assets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT creative_assets_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES auth.users(id)
);
```

