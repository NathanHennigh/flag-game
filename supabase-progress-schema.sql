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
