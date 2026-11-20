-- Run this ONCE in Supabase: SQL Editor -> New query -> paste -> Run

create table public.photos (
  id uuid primary key default gen_random_uuid(),
  path text not null,
  album text not null default 'Everyday',
  name text,
  fav boolean not null default false,
  user_id uuid default auth.uid(),
  created_at timestamptz not null default now()
);

alter table public.photos enable row level security;

create policy "members read"   on public.photos for select to authenticated using (true);
create policy "members insert" on public.photos for insert to authenticated with check (true);
create policy "members update" on public.photos for update to authenticated using (true) with check (true);
create policy "members delete" on public.photos for delete to authenticated using (true);

insert into storage.buckets (id, name, public) values ('photos', 'photos', false)
on conflict (id) do nothing;

create policy "members manage photo files" on storage.objects
  for all to authenticated
  using (bucket_id = 'photos') with check (bucket_id = 'photos');
