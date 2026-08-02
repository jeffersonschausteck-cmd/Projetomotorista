# Driver Platform

Plataforma de gestão para motoristas particulares e de aplicativo (Uber, 99,
inDrive, Maxim). Ver as decisões de arquitetura em `supabase/README.md`.

Nome do app e bundle IDs (`com.driverplatform.app`) são provisórios —
renomear quando a marca for definida.

## Stack

- Flutter (Android, iOS, Web) — Clean Architecture, feature-first
- Riverpod (`riverpod_generator`) para estado
- go_router para navegação
- Supabase (Postgres + Auth + Storage + Realtime + Edge Functions)

## Setup local

1. Instale as dependências:
   ```
   flutter pub get
   ```
2. Gere os arquivos `.g.dart` (Riverpod/Freezed/json_serializable):
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Copie `dart_define.example.json` para `dart_define.json` e preencha com
   a URL e a publishable key do seu projeto Supabase (nunca commitar esse
   arquivo — já está no `.gitignore`).
4. Aplique as migrations em `supabase/migrations/` no seu projeto Supabase
   (SQL editor do dashboard ou Supabase CLI).
5. Rode o app:
   ```
   flutter run --dart-define-from-file=dart_define.json
   ```

## Estrutura

```
lib/
  app/            # bootstrap, tema, rotas (go_router)
  core/           # erros, env, network, utils e widgets compartilhados
  features/       # feature-first: auth, dashboard, rides, clients, vehicles
                   # cada feature: domain/ (entities + repositories) ->
                   # data/ (impl) -> presentation/ (providers + screens)
```

## Roadmap

Fase 0 (fundação: schema, auth, monorepo, design system) concluída. Próxima:
Fase 1 — MVP (cadastro de corrida, agenda, clientes, dashboard básico).
