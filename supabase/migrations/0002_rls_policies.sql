-- Fase 0: Row Level Security — isolamento por motorista desde o primeiro dia.
-- Cada motorista só enxerga e altera suas próprias linhas.
-- Base pronta para o multi-tenant SaaS da Fase 7, sem migração futura de dados.

alter table profiles enable row level security;
alter table vehicles enable row level security;
alter table clients enable row level security;
alter table locations enable row level security;
alter table rides enable row level security;

-- profiles: o próprio registro é identificado pelo id (== auth.uid())
create policy "profiles_select_own" on profiles
  for select using (id = auth.uid());
create policy "profiles_insert_own" on profiles
  for insert with check (id = auth.uid());
create policy "profiles_update_own" on profiles
  for update using (id = auth.uid());
create policy "profiles_delete_own" on profiles
  for delete using (id = auth.uid());

-- vehicles
create policy "vehicles_select_own" on vehicles
  for select using (driver_id = auth.uid());
create policy "vehicles_insert_own" on vehicles
  for insert with check (driver_id = auth.uid());
create policy "vehicles_update_own" on vehicles
  for update using (driver_id = auth.uid());
create policy "vehicles_delete_own" on vehicles
  for delete using (driver_id = auth.uid());

-- clients
create policy "clients_select_own" on clients
  for select using (driver_id = auth.uid());
create policy "clients_insert_own" on clients
  for insert with check (driver_id = auth.uid());
create policy "clients_update_own" on clients
  for update using (driver_id = auth.uid());
create policy "clients_delete_own" on clients
  for delete using (driver_id = auth.uid());

-- locations
create policy "locations_select_own" on locations
  for select using (driver_id = auth.uid());
create policy "locations_insert_own" on locations
  for insert with check (driver_id = auth.uid());
create policy "locations_update_own" on locations
  for update using (driver_id = auth.uid());
create policy "locations_delete_own" on locations
  for delete using (driver_id = auth.uid());

-- rides
create policy "rides_select_own" on rides
  for select using (driver_id = auth.uid());
create policy "rides_insert_own" on rides
  for insert with check (driver_id = auth.uid());
create policy "rides_update_own" on rides
  for update using (driver_id = auth.uid());
create policy "rides_delete_own" on rides
  for delete using (driver_id = auth.uid());
