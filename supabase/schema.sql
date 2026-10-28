-- Banco do app Tiboh Pedidos no Supabase.
-- Pode rodar num projeto que já tem outro app: tudo aqui usa o prefixo tiboh_ e não
-- mexe nas tabelas existentes. Rode uma vez em: SQL Editor > New query > colar tudo > Run.

-- Todos os dados do app (pedidos, estoque, cardápio) ficam nesta tabela,
-- um registro por documento: colecao "pedidos" + id do pedido, "estoque" + "cookies", etc.
create table if not exists public.tiboh_docs (
  colecao text not null,
  id text not null,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  primary key (colecao, id)
);

-- Quem pode usar o app: só os e-mails desta lista veem e mudam os pedidos.
create table if not exists public.tiboh_membros (
  email text primary key
);

alter table public.tiboh_docs enable row level security;
alter table public.tiboh_membros enable row level security;

-- Projetos novos do Supabase nem sempre dão acesso às tabelas criadas por SQL.
-- Quem decide o que cada um vê são as regras (RLS) abaixo.
grant select, insert, update, delete on public.tiboh_docs to authenticated;

create or replace function public.tiboh_eh_membro() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.tiboh_membros where lower(email) = lower(auth.jwt() ->> 'email'));
$$;
grant execute on function public.tiboh_eh_membro() to authenticated;

drop policy if exists "tiboh membros leem" on public.tiboh_docs;
drop policy if exists "tiboh membros criam" on public.tiboh_docs;
drop policy if exists "tiboh membros alteram" on public.tiboh_docs;
drop policy if exists "tiboh membros apagam" on public.tiboh_docs;
create policy "tiboh membros leem" on public.tiboh_docs for select to authenticated using (public.tiboh_eh_membro());
create policy "tiboh membros criam" on public.tiboh_docs for insert to authenticated with check (public.tiboh_eh_membro());
create policy "tiboh membros alteram" on public.tiboh_docs for update to authenticated using (public.tiboh_eh_membro()) with check (public.tiboh_eh_membro());
create policy "tiboh membros apagam" on public.tiboh_docs for delete to authenticated using (public.tiboh_eh_membro());

-- Atualização ao vivo entre celular e computador.
do $$ begin
  alter publication supabase_realtime add table public.tiboh_docs;
exception when duplicate_object then null;
end $$;

-- Troque pelos e-mails de quem vai usar o app e rode esta parte também:
-- insert into public.tiboh_membros (email) values ('email-da-leticia@exemplo.com'), ('seu-email@exemplo.com');
