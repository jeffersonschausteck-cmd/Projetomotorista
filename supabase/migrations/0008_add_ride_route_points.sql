-- Fase 4: rastreamento em primeiro plano durante a corrida. Os pontos GPS
-- capturados entre "iniciar" e "finalizar" viram um breadcrumb salvo aqui —
-- baixo volume (dezenas de pontos por corrida), não justifica tabela própria
-- com RLS e índices só pra isso.
alter table rides add column route_points jsonb;
