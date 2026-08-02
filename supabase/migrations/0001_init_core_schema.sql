-- Fase 0: schema núcleo da plataforma (profiles, vehicles, clients, locations, rides)
-- Convenção: texto + CHECK em vez de ENUM nativo (evolução de valores sem ALTER TYPE).
-- Convenção: toda tabela de domínio carrega driver_id (isolamento por motorista, base para RLS na 0002).

create extension if not exists "pgcrypto";

create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- =========================================================
-- profiles: dados do motorista, 1:1 com auth.users
-- =========================================================
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  email text,
  avatar_url text,
  daily_goal numeric(10,2),
  monthly_goal numeric(10,2),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger profiles_set_updated_at
  before update on profiles
  for each row execute function set_updated_at();

-- =========================================================
-- vehicles: veículos do motorista (campos de manutenção chegam na Fase 2)
-- =========================================================
create table vehicles (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  nickname text not null,
  plate text,
  current_km numeric(10,1),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index vehicles_driver_id_idx on vehicles(driver_id);

create trigger vehicles_set_updated_at
  before update on vehicles
  for each row execute function set_updated_at();

-- =========================================================
-- clients: cadastro de clientes do motorista
-- =========================================================
create table clients (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  name text not null,
  phone text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index clients_driver_id_idx on clients(driver_id);

create trigger clients_set_updated_at
  before update on clients
  for each row execute function set_updated_at();

-- =========================================================
-- locations: locais salvos (favoritos do motorista e/ou de um cliente)
-- reutilizado para autocomplete de origem/destino
-- =========================================================
create table locations (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  client_id uuid references clients(id) on delete set null,
  label text,
  address text not null,
  latitude double precision,
  longitude double precision,
  is_favorite boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index locations_driver_id_idx on locations(driver_id);
create index locations_client_id_idx on locations(client_id);

create trigger locations_set_updated_at
  before update on locations
  for each row execute function set_updated_at();

-- =========================================================
-- rides: tabela única para agendamentos, corridas particulares e
-- corridas importadas via OCR de plataformas (Uber/99/inDrive/...).
-- Uma tabela só porque as estatísticas (Fase 5) precisam agregar
-- todas as origens juntas sem UNION entre tabelas.
-- =========================================================
create table rides (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  client_id uuid references clients(id) on delete set null,
  vehicle_id uuid references vehicles(id) on delete set null,

  source text not null default 'manual'
    check (source in ('manual', 'scheduled', 'platform_ocr')),
  platform text not null default 'particular'
    check (platform in ('particular', 'uber', '99', 'indrive', 'maxim', 'other')),
  status text not null default 'pending'
    check (status in ('pending', 'accepted', 'declined', 'in_progress', 'completed', 'cancelled')),

  origin_address text,
  origin_lat double precision,
  origin_lng double precision,
  destination_address text,
  destination_lat double precision,
  destination_lng double precision,

  scheduled_at timestamptz,
  accepted_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  cancelled_at timestamptz,

  gross_amount numeric(10,2),
  payment_method text
    check (payment_method in ('cash', 'pix', 'card', 'app', 'other')),

  -- campos alimentados pelo OCR (Fase 3); nulos até lá
  distance_to_pickup_km numeric(6,2),
  trip_distance_km numeric(6,2),
  estimated_duration_min integer,

  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index rides_driver_id_idx on rides(driver_id);
create index rides_client_id_idx on rides(client_id);
create index rides_status_idx on rides(status);
create index rides_scheduled_at_idx on rides(scheduled_at);
create index rides_completed_at_idx on rides(completed_at);

create trigger rides_set_updated_at
  before update on rides
  for each row execute function set_updated_at();
