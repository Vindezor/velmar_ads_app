# Guía de Arquitectura - Velmar Ads

Este documento describe la arquitectura de software del proyecto **Velmar Ads**, desarrollada bajo los principios de **Clean Architecture** (Arquitectura Limpia) y utilizando el patrón de diseño **BloC** para el manejo de estados en Flutter.

El objetivo de esta estructura es mantener la base de código modular, altamente testeable, escalable e independiente de frameworks y librerías externas.

---

## 📌 Estructura General del Proyecto

El código fuente de la aplicación se encuentra dentro del directorio `lib/`, el cual se divide principalmente en dos carpetas: `core/` (código compartido) y `features/` (módulos o funcionalidades del negocio).

```
lib/
├── core/                    # Código común y transversal a toda la aplicación
│   ├── common/              # Widgets, Cubits y Entidades compartidas (ej. User)
│   ├── error/               # Definición de fallos (Failures) y excepciones
│   ├── router/              # Configuración de rutas (GoRouter)
│   ├── secrets/             # Configuración de llaves de APIs y secrets (Supabase)
│   ├── theme/               # Paleta de colores y estilos globales de diseño
│   ├── usecase/             # Definición base/contrato para los casos de uso
│   └── utils/               # Funciones de utilidad (ej. snackbar)
│
├── features/                # Módulos del negocio basados en características
│   ├── auth/                # Módulo de autenticación (Login, Registro, etc.)
│   │   ├── data/            # Implementación de datos (Modelos, Fuentes de Datos, Repositorios)
│   │   ├── domain/          # Lógica pura del negocio (Entidades, Repositorios, Casos de Uso)
│   │   └── presentation/    # Interfaz de Usuario y Gestión de Estado (Bloc, Páginas, Widgets)
│   └── dashboard/           # Módulo de la pantalla principal tras iniciar sesión
│       └── presentation/    # (Actualmente solo contiene UI)
│
├── init_dependencies.dart   # Inyección de dependencias centralizada (GetIt)
└── main.dart                # Punto de entrada de la aplicación
```

---

## 📂 Capas de una Característica (`features/`)

Cada carpeta dentro de `features/` implementa las tres capas principales de la Arquitectura Limpia:

### 1. 🌐 Capa de Dominio (`domain/`)
Es el núcleo de la funcionalidad y es **totalmente independiente** de cualquier librería externa, base de datos o interfaz de usuario.
*   **`entities/`**: Objetos de datos simples que representan la información del negocio (ej. `User`). Si una entidad es compartida por múltiples características, se ubica en `lib/core/common/`.
*   **`repository/`**: Interfaces abstractas (contratos) que definen el comportamiento de obtención o manipulación de datos. La capa de dominio *no sabe de dónde provienen* los datos (de Supabase, de una API o de la base de datos local); solo define la firma de los métodos.
*   **`usecases/`**: Clases de responsabilidad única que ejecutan una acción de negocio específica (ej. `UserLogin`, `UserSignUp`). Todos los casos de uso heredan de la interfaz base `UseCase` en `core/usecase/usecase.dart` y retornan un resultado de tipo `Either<Failure, SuccessType>` usando `fpdart`.

### 2. 🔌 Capa de Datos (`data/`)
Implementa las interfaces definidas en la capa de dominio y se encarga de la comunicación directa con APIs externas, bases de datos y persistencia.
*   **`datasources/`**: Clases que interactúan directamente con fuentes de datos externas (ej. `AuthRemoteDataSource` usando `SupabaseClient`). Lanza excepciones de bajo nivel como `ServerException` o `AuthException`.
*   **`models/`**: Extensiones de las entidades del dominio que añaden serialización JSON (`fromJson`, `toJson`). Nos permite transformar la información cruda de la API en objetos tipados.
*   **`repositories/`**: Implementaciones concretas de las interfaces del repositorio del dominio (ej. `AuthRepositoryImpl`). Esta clase consume los data sources, captura excepciones de bajo nivel y las retorna formateadas como un `Failure` (izquierda) o el valor de éxito (derecha) en un objeto `Either`.

### 3. 🎨 Capa de Presentación (`presentation/`)
Responsable de renderizar la interfaz gráfica y manejar la interacción del usuario.
*   **`bloc/` o `cubit/`**: Gestión de estados utilizando `flutter_bloc`. Los Blocs reciben eventos de la interfaz de usuario, invocan los casos de uso correspondientes y emiten nuevos estados para actualizar la pantalla.
*   **`pages/`**: Pantallas principales declaradas en las rutas de navegación (ej. `LoginPage`). Suelen utilizar `BlocConsumer` o `BlocBuilder` para reaccionar a los cambios de estado.
*   **`widgets/`**: Subcomponentes reutilizables o partes específicas de una página (ej. `LoginForm`).

---

## 🛠️ Tecnologías Clave y Flujo de Trabajo

### 1. Inyección de Dependencias (`get_it`)
Toda la configuración de inyección de dependencias está centralizada en [init_dependencies.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/init_dependencies.dart).
*   Se utiliza `serviceLocator` (`GetIt.instance`) para obtener instancias de clases.
*   **`registerFactory`**: Crea una nueva instancia de la clase cada vez que es solicitada (recomendado para Blocs, Use Cases y Repositorios).
*   **`registerLazySingleton`**: Crea y mantiene una única instancia compartida durante todo el ciclo de vida de la app, instanciándose únicamente cuando se requiere por primera vez (ej. `SupabaseClient` y `AppUserCubit`).

### 2. Manejo de Estados (`flutter_bloc`)
*   Para estados globales de sesión y datos persistentes a nivel de app, usamos **Cubits** (como `AppUserCubit` en `lib/core/common/cubits/app_user/`).
*   Para lógica específica de formularios y pantallas complejas, usamos **Blocs** estructurados con eventos (`Event`) y estados (`State`).
*   **Coordinación entre Blocs e Inyección Cruzada**: Si un Bloc de funcionalidad local necesita consultar información del usuario logueado (como el `userId`), se le debe inyectar el `AppUserCubit` en su constructor. La UI no debe responsabilizarse de extraer y pasar identificadores que ya están globalmente disponibles, delegando esa lógica al Bloc y cumpliendo con los principios SOLID de encapsulamiento y responsabilidad única.
*   **Encapsulamiento de Dependencias**: Por convención, las dependencias inyectadas en los Blocs deben almacenarse como variables privadas finales (ej. `final GetDashboardData _getDashboardData;`) y asignarse en la lista de inicializadores del constructor. Para evitar advertencias del compilador de Dart, se coloca el ignore de archivo `// ignore_for_file: prefer_initializing_formals`.



### 3. Enrutamiento (`go_router`)
La navegación está declarada en [app_router.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/router/app_router.dart).
*   Escucha de manera reactiva el flujo del `AppUserCubit` mediante un `GoRouterRefreshStream`.
*   Realiza redirecciones automáticas en base a la sesión:
    *   Si no hay sesión iniciada, cualquier intento de acceder a rutas privadas redirige a `/login`.
    *   Si hay una sesión activa, cualquier intento de acceder a `/login` o `/register` redirige automáticamente a `/dashboard`.

---

## 🎨 Reglas de Diseño e Integración UI

El desarrollo visual de las interfaces en **Velmar Ads** sigue un flujo estructurado:
*   **Traducción de Diseños HTML**: La interfaz gráfica es proporcionada por un diseñador en formato **HTML/CSS**. El agente de IA es responsable de traducir fielmente estos diseños a componentes y vistas de Flutter.
*   **Consistencia Temática**: Queda estrictamente prohibido utilizar colores estáticos/hardcodeados (ej. `Colors.blue`) o espaciados arbitrarios en los widgets. Se debe hacer uso exclusivo del sistema de diseño definido en la aplicación:
    *   **Colores**: Usar la paleta de colores de [app_pallete.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/theme/app_pallete.dart) a través de `AppPallete` o mediante el `Theme.of(context).colorScheme` configurado en [theme.dart](file:///d:/AMD/Escritorio/Velmar_Ads/Code/Flutter/velmar_ads/lib/core/theme/theme.dart).
    *   **Tipografía**: Utilizar los estilos de `AppTypography` o el tema de texto (`Theme.of(context).textTheme`).
    *   **Bordes y Radios**: Utilizar los radios predefinidos en `AppRadius` (ej. `AppRadius.md` para campos de entrada y botones, `AppRadius.lg` para tarjetas).
    *   **Espaciados**: Utilizar las dimensiones de `AppSpacing` para mantener la consistencia vertical y horizontal.
*   **Componentes Material Design**: Utilizar y extender de forma limpia los componentes proporcionados por Flutter Material (ej. `Card`, `ElevatedButton`, `OutlinedButton`, `TextFormField`, etc.) que ya están pre-estilizados en el tema central.

---


## 💡 Reglas para Crear Nuevos Módulos o Características

> [!WARNING]
> * **Prohibición de Importaciones Cruzadas (Acoplamiento de Features)**: Queda estrictamente prohibido importar clases de la capa de datos (`Models`, `DataSources`, `RepositoriesImpl`) de una característica en otra. El acoplamiento entre características debe ocurrir únicamente a través de la capa `core/common/` mediante entidades y cubits globales compartidos (por ejemplo, utilizando `User` y `AppUserCubit` para consultar la sesión del usuario).
> * **Autonomía de Características Existentes**: Queda estrictamente prohibido modificar modelos, data sources, entidades o repositorios de características ya establecidas (como `auth`) con el único fin de alimentar o satisfacer los requerimientos de datos de una nueva característica (como `dashboard`). Cada característica debe resolver sus consultas y persistencia de forma independiente mediante su propio `DataSource`, consumiendo de `core` únicamente identificadores compartidos de sesión (como el ID del usuario).


Cuando se te solicite agregar una nueva funcionalidad (ej. `campaigns`, `analytics`), debes seguir este orden y estructura:


1.  **Crear Carpetas**:
    *   `lib/features/nombre_feature/domain/entities`
    *   `lib/features/nombre_feature/domain/repository`
    *   `lib/features/nombre_feature/domain/usecases`
    *   `lib/features/nombre_feature/data/datasources`
    *   `lib/features/nombre_feature/data/models`
    *   `lib/features/nombre_feature/data/repositories`
    *   `lib/features/nombre_feature/presentation/bloc`
    *   `lib/features/nombre_feature/presentation/pages`
    *   `lib/features/nombre_feature/presentation/widgets`
2.  **Definir Entidad y Repositorio en Dominio**: Crea la clase base y la interfaz abstracta del repositorio.
3.  **Implementar Data Source e Impl del Repositorio**: Conecta la API/Supabase y haz el parseo con modelos. Recuerda capturar excepciones y retornar `Either<Failure, T>`.
4.  **Crear Casos de Uso**: Define clases de acción única que extiendan `UseCase`.
5.  **Crear BLoC/Cubit**: Gestiona el flujo del estado en base a eventos de usuario y llamadas a casos de uso.
6.  **Registrar Dependencias**: Agrega la inyección de los nuevos componentes en `lib/init_dependencies.dart` siguiendo el patrón existente.
7.  **Crear Vistas y Enlazar en Router**: Diseña las pantallas y regístralas en `lib/core/router/app_router.dart`.

---

## 🗄️ Esquema de Base de Datos (Supabase)

A continuación se detalla el esquema de tablas en Supabase. Utiliza esta referencia al estructurar los modelos de datos en la capa `data/models/` y realizar consultas en los data sources:

```sql
-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

-- Configuración general de la app
CREATE TABLE public.app_config (
  key text NOT NULL,
  value text NOT NULL,
  description text,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT app_config_pkey PRIMARY KEY (key)
);

-- Perfiles de usuario (conectado con auth.users de Supabase)
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

-- Ciudades de cobertura
CREATE TABLE public.cities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  country text NOT NULL DEFAULT 'Venezuela'::text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT cities_pkey PRIMARY KEY (id)
);

-- Zonas dentro de las ciudades
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

-- Clases de pantallas (ej. pantallas viales, centros comerciales, etc.)
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

-- Unidades de medida (ej. píxeles, metros)
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

-- Categorías de tamaño
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

-- Multiplicadores de precio por horas pico/zonas
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

-- Vallas publicitarias (pantallas / billboards)
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

-- Tipos de reserva (ej. duración del slot, anuncios máximos)
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

-- Recursos creativos subidos por los usuarios (videos, imágenes)
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

-- Solicitudes de recarga de créditos
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

-- Reservas de vallas / pantallas viales
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

-- Historial de movimientos de créditos (Ledger)
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
```

