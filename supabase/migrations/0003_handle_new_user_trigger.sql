-- Cria a linha em profiles automaticamente quando um usuário se cadastra.
-- Evita fazer esse insert a partir do client: no momento do signUp (antes da
-- confirmação de e-mail) pode não haver sessão ativa, e o insert client-side
-- cairia na RLS de profiles (id = auth.uid()).

create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email
  );
  return new;
end;
$$ language plpgsql security definer set search_path = public;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();
