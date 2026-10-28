-- Banco do app Tiboh Pedidos no Supabase.
-- Rode uma vez em: Supabase > SQL Editor > New query > colar tudo > Run.

-- Todos os dados do app (pedidos, estoque, cardápio) ficam nesta tabela,
-- um registro por documento: colecao "pedidos" + id do pedido, "estoque" + "cookies", etc.
create table if not exists public.docs (
  colecao text not null,
  id text not null,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  primary key (colecao, id)
);

-- Quem pode usar o app: só os e-mails desta lista veem e mudam os pedidos.
create table if not exists public.membros (
  email text primary key
);

alter table public.docs enable row level security;
alter table public.membros enable row level security;

create or replace function public.eh_membro() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.membros where lower(email) = lower(auth.jwt() ->> 'email'));
$$;

drop policy if exists "membros leem" on public.docs;
drop policy if exists "membros criam" on public.docs;
drop policy if exists "membros alteram" on public.docs;
drop policy if exists "membros apagam" on public.docs;
create policy "membros leem" on public.docs for select to authenticated using (public.eh_membro());
create policy "membros criam" on public.docs for insert to authenticated with check (public.eh_membro());
create policy "membros alteram" on public.docs for update to authenticated using (public.eh_membro()) with check (public.eh_membro());
create policy "membros apagam" on public.docs for delete to authenticated using (public.eh_membro());

-- Atualização ao vivo entre celular e computador.
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null;
end $$;

-- Troque pelos e-mails de quem vai usar o app e rode esta parte também:
-- insert into public.membros (email) values ('email-da-leticia@exemplo.com'), ('seu-email@exemplo.com');
