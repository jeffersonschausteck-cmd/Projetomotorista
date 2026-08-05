-- Fase 2: financeiro (despesas) e controle de veículo (lembretes de manutenção)

-- =========================================================
-- expenses: despesas do motorista (combustível, pedágio, seguro, ...)
-- =========================================================
create table expenses (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  vehicle_id uuid references vehicles(id) on delete set null,

  category text not null
    check (category in ('fuel', 'toll', 'wash', 'insurance', 'ipva', 'tires', 'oil_change', 'maintenance', 'other')),
  amount numeric(10,2) not null,
  expense_date date not null default current_date,
  odometer_km numeric(10,1),
  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index expenses_driver_id_idx on expenses(driver_id);
create index expenses_vehicle_id_idx on expenses(vehicle_id);
create index expenses_expense_date_idx on expenses(expense_date);

create trigger expenses_set_updated_at
  before update on expenses
  for each row execute function set_updated_at();

alter table expenses enable row level security;

create policy "expenses_select_own" on expenses
  for select using (driver_id = auth.uid());
create policy "expenses_insert_own" on expenses
  for insert with check (driver_id = auth.uid());
create policy "expenses_update_own" on expenses
  for update using (driver_id = auth.uid());
create policy "expenses_delete_own" on expenses
  for delete using (driver_id = auth.uid());

-- =========================================================
-- maintenance_reminders: lembretes por veículo, tipos abertos, por KM e/ou
-- data — o status (em dia/vencendo/vencido) é calculado no app, não aqui.
-- =========================================================
create table maintenance_reminders (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references profiles(id) on delete cascade,
  vehicle_id uuid not null references vehicles(id) on delete cascade,

  type text not null
    check (type in ('oil_change', 'revision', 'tires', 'insurance', 'ipva', 'documentation', 'other')),
  due_km numeric(10,1),
  due_date date,
  last_done_at date,
  notes text,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index maintenance_reminders_driver_id_idx on maintenance_reminders(driver_id);
create index maintenance_reminders_vehicle_id_idx on maintenance_reminders(vehicle_id);

create trigger maintenance_reminders_set_updated_at
  before update on maintenance_reminders
  for each row execute function set_updated_at();

alter table maintenance_reminders enable row level security;

create policy "maintenance_reminders_select_own" on maintenance_reminders
  for select using (driver_id = auth.uid());
create policy "maintenance_reminders_insert_own" on maintenance_reminders
  for insert with check (driver_id = auth.uid());
create policy "maintenance_reminders_update_own" on maintenance_reminders
  for update using (driver_id = auth.uid());
create policy "maintenance_reminders_delete_own" on maintenance_reminders
  for delete using (driver_id = auth.uid());
