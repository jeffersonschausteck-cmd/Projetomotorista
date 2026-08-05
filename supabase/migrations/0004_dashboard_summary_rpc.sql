-- Fase 1: agregação do dashboard feita no banco (não no cliente) — evita
-- puxar todas as corridas do período só para somar em Dart.
create or replace function get_dashboard_summary(period_from timestamptz, period_to timestamptz)
returns table (
  total_rides bigint,
  gross_amount numeric,
  total_km numeric
)
security invoker
set search_path = public
language sql
stable
as $$
  select
    count(*) as total_rides,
    coalesce(sum(r.gross_amount), 0) as gross_amount,
    coalesce(sum(r.trip_distance_km), 0) as total_km
  from rides r
  where r.driver_id = auth.uid()
    and r.status = 'completed'
    and r.completed_at between period_from and period_to
    and r.deleted_at is null;
$$;
