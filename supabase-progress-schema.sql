create table if not exists public.world_flags_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.world_flags_progress enable row level security;

drop policy if exists "Users can read their own world flags progress" on public.world_flags_progress;
create policy "Users can read their own world flags progress"
on public.world_flags_progress
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own world flags progress" on public.world_flags_progress;
create policy "Users can insert their own world flags progress"
on public.world_flags_progress
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own world flags progress" on public.world_flags_progress;
create policy "Users can update their own world flags progress"
on public.world_flags_progress
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create or replace function public.touch_world_flags_progress_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists touch_world_flags_progress_updated_at on public.world_flags_progress;
create trigger touch_world_flags_progress_updated_at
before update on public.world_flags_progress
for each row
execute function public.touch_world_flags_progress_updated_at();

create table if not exists public.world_flags_battle_rooms (
  room_code text primary key,
  room jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint world_flags_battle_rooms_code_shape check (room_code ~ '^[A-Z2-9]{5}$'),
  constraint world_flags_battle_rooms_room_object check (jsonb_typeof(room) = 'object')
);

alter table public.world_flags_battle_rooms enable row level security;

grant select, insert, update on public.world_flags_battle_rooms to anon, authenticated;

drop policy if exists "Anyone can read recent world flags battle rooms" on public.world_flags_battle_rooms;
create policy "Anyone can read recent world flags battle rooms"
on public.world_flags_battle_rooms
for select
to anon, authenticated
using (updated_at > now() - interval '12 hours');

drop policy if exists "Anyone can create world flags battle rooms" on public.world_flags_battle_rooms;
create policy "Anyone can create world flags battle rooms"
on public.world_flags_battle_rooms
for insert
to anon, authenticated
with check (room_code ~ '^[A-Z2-9]{5}$' and jsonb_typeof(room) = 'object');

drop policy if exists "Anyone can update recent world flags battle rooms" on public.world_flags_battle_rooms;
create policy "Anyone can update recent world flags battle rooms"
on public.world_flags_battle_rooms
for update
to anon, authenticated
using (true)
with check (room_code ~ '^[A-Z2-9]{5}$' and jsonb_typeof(room) = 'object');

create or replace function public.touch_world_flags_battle_rooms_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists touch_world_flags_battle_rooms_updated_at on public.world_flags_battle_rooms;
create trigger touch_world_flags_battle_rooms_updated_at
before update on public.world_flags_battle_rooms
for each row
execute function public.touch_world_flags_battle_rooms_updated_at();
