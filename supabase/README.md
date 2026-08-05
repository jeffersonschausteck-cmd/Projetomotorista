# Banco de dados — Fase 0

Schema núcleo da plataforma, aplicado via Supabase CLI ou pelo SQL editor do
dashboard, em ordem:

1. `migrations/0001_init_core_schema.sql` — tabelas `profiles`, `vehicles`,
   `clients`, `locations`, `rides`.
2. `migrations/0002_rls_policies.sql` — Row Level Security, isolando os dados
   por `driver_id` (ou `id` em `profiles`).

## Decisões de modelagem

- **`rides` é uma tabela única** para agendamentos, corridas particulares e
  corridas importadas por OCR de plataformas (`source`: `manual` |
  `scheduled` | `platform_ocr`). Estatísticas agregadas (Fase 5) precisam
  cruzar todas as origens sem `UNION` entre tabelas.
- **Enums como `text` + `CHECK`**, não `ENUM` nativo do Postgres — permite
  adicionar plataformas/categorias novas com uma migração simples de
  constraint, sem as restrições de `ALTER TYPE`.
- **`driver_id` em toda tabela de domínio + RLS habilitado desde a Fase 0**,
  mesmo antes do multi-tenant SaaS (Fase 7) existir de fato — é a forma
  correta de modelar dados que já pertencem logicamente a um motorista, e
  evita uma migração de segurança arriscada mais tarde.
- **Soft delete** (`deleted_at`) em `clients` e `rides` — cancelar ou excluir
  não pode apagar histórico usado nas estatísticas.
- **Colunas de OCR já existem em `rides`** (`platform`,
  `distance_to_pickup_km`, `trip_distance_km`, `estimated_duration_min`),
  mesmo que fiquem `NULL` até a Fase 3 — evita `ALTER TABLE` quando o OCR
  for implementado.

## Fora de escopo na Fase 0 (de propósito)

- Tabelas de financeiro (`expenses`) e manutenção detalhada de veículo —
  entram na Fase 2, junto com o restante do módulo financeiro.
- Tabelas de IA/estatísticas agregadas — Fase 5, quando houver volume real
  de corridas para agregar.

## Fase 3 — OCR inteligente

- `migrations/0007_add_ride_category.sql` — coluna `category` em `rides`
  (texto livre, ex: "UberX", "99 Comfort").
- `functions/extract-ride-from-image/` — Edge Function (Deno) que recebe um
  print de tela em base64, chama a IA de visão (Claude, via
  `npm:@anthropic-ai/sdk`) com extração estruturada forçada (`tool_choice`
  + `strict: true`) e devolve os campos já tipados. A imagem nunca é
  persistida em Storage; a função nunca grava nada em `rides` — quem grava é
  sempre o app, depois que o motorista confirma os dados na tela de revisão.
- **Requer a secret `ANTHROPIC_API_KEY` no projeto** (chave de
  console.anthropic.com), configurada via:
  ```
  curl -X POST "https://api.supabase.com/v1/projects/{ref}/secrets" \
    -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    --data '[{"name":"ANTHROPIC_API_KEY","value":"sk-ant-..."}]'
  ```
  Sem essa secret configurada, a função responde 500 e o app mostra a
  mensagem de erro na tela de importação — o restante do app funciona
  normalmente (a importação por foto é a única funcionalidade bloqueada).
