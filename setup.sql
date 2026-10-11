-- Noman Trader: run this entire script in Supabase SQL Editor AFTER creating your Auth user.
-- This keeps registrations private and allows only user IDs listed in admin_users to manage content.

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
drop policy if exists "Admins can view their own admin row" on public.admin_users;
create policy "Admins can view their own admin row"
on public.admin_users for select to authenticated
using (user_id = auth.uid());

alter table public.trading_history add column if not exists image_url text;
alter table public.trading_history add column if not exists notes text;
alter table public.trading_history add column if not exists account_type text not null default 'MT5';
alter table public.trading_history add column if not exists result text not null default 'Report pending';
alter table public.trading_history add column if not exists trade_date date not null default current_date;
alter table public.trading_history add column if not exists created_at timestamptz not null default now();

alter table public.reviews add column if not exists reviewer_name text;
alter table public.reviews add column if not exists review_text text;
alter table public.reviews add column if not exists created_at timestamptz not null default now();

alter table public.registrations add column if not exists whatsapp text;
alter table public.registrations add column if not exists full_name text;
alter table public.registrations add column if not exists email text;
alter table public.registrations add column if not exists interest text not null default 'Trading Community + Signals';
alter table public.registrations add column if not exists created_at timestamptz not null default now();

alter table public.trading_history enable row level security;
alter table public.reviews enable row level security;
alter table public.registrations enable row level security;

drop policy if exists "Public can view trading history" on public.trading_history;
drop policy if exists "Public can view reviews" on public.reviews;
drop policy if exists "Admin can insert trading history" on public.trading_history;
drop policy if exists "Admin can update trading history" on public.trading_history;
drop policy if exists "Admin can delete trading history" on public.trading_history;
drop policy if exists "Admin can manage reviews" on public.reviews;
drop policy if exists "Anyone can submit membership request" on public.registrations;
drop policy if exists "Admin can view registrations" on public.registrations;

create policy "Public can view trading history" on public.trading_history
for select to anon, authenticated using (true);
create policy "Admin can insert trading history" on public.trading_history
for insert to authenticated with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
create policy "Admin can update trading history" on public.trading_history
for update to authenticated using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
create policy "Admin can delete trading history" on public.trading_history
for delete to authenticated using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

create policy "Public can view reviews" on public.reviews
for select to anon, authenticated using (true);
create policy "Admin can manage reviews" on public.reviews
for all to authenticated using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

create policy "Anyone can submit membership request" on public.registrations
for insert to anon, authenticated with check (
  length(trim(full_name)) between 2 and 120 and
  length(trim(email)) between 5 and 254 and
  length(trim(interest)) between 2 and 100
);
create policy "Admin can view registrations" on public.registrations
for select to authenticated using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Public image bucket. Public visitors can view report images; only admin users can upload/change/delete.
insert into storage.buckets (id, name, public)
values ('noman-reports', 'noman-reports', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view Noman reports" on storage.objects;
drop policy if exists "Admin can upload Noman reports" on storage.objects;
drop policy if exists "Admin can update Noman reports" on storage.objects;
drop policy if exists "Admin can delete Noman reports" on storage.objects;
create policy "Public can view Noman reports" on storage.objects
for select to anon, authenticated using (bucket_id = 'noman-reports');
create policy "Admin can upload Noman reports" on storage.objects
for insert to authenticated with check (
  bucket_id = 'noman-reports' and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);
create policy "Admin can update Noman reports" on storage.objects
for update to authenticated using (
  bucket_id = 'noman-reports' and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
) with check (
  bucket_id = 'noman-reports' and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);
create policy "Admin can delete Noman reports" on storage.objects
for delete to authenticated using (
  bucket_id = 'noman-reports' and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);
