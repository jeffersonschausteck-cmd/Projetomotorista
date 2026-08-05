-- Fase 2: dashboard passa a devolver também despesas e lucro líquido do
-- período. Postgres não permite CREATE OR REPLACE mudar o tipo de retorno
-- (novas colunas OUT contam como mudança) — precisa dropar antes.
drop function if exists get_dashboard_summary(timestamptz, timestamptz);

create function get_dashboard_summary(period_from timestamptz, period_to timestamptz)
returns table (
  total_rides bigint,
  gross_amount numeric,
  total_km numeric,
  total_expenses numeric,
  net_amount numeric
)
security invoker
set search_path = public
language sql
stable
as $$
  select
    rides_agg.total_rides,
    rides_agg.gross_amount,
    rides_agg.total_km,
    expenses_agg.total_expenses,
    rides_agg.gross_amount - expenses_agg.total_expenses as net_amount
  from (
    select
      count(*) as total_rides,
      coalesce(sum(r.gross_amount), 0) as gross_amount,
      coalesce(sum(r.trip_distance_km), 0) as total_km
    from rides r
    where r.driver_id = auth.uid()
      and r.status = 'completed'
      and r.completed_at between period_from and period_to
      and r.deleted_at is null
  ) rides_agg
  cross join (
    select coalesce(sum(e.amount), 0) as total_expenses
    from expenses e
    where e.driver_id = auth.uid()
      and e.expense_date between period_from::date and period_to::date
      and e.deleted_at is null
  ) expenses_agg;
$$;
