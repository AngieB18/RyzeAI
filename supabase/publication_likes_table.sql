-- Create publication_likes table
create table if not exists publication_likes (
  user_id uuid not null references auth.users(id) on delete cascade,
  project_id uuid not null references projects(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, project_id)
);

-- Create index for faster queries
create index if not exists publication_likes_user_id_idx on publication_likes(user_id);
create index if not exists publication_likes_project_id_idx on publication_likes(project_id);

-- Enable RLS (Row Level Security)
alter table publication_likes enable row level security;

-- Anyone can view all likes (public data)
create policy "Anyone can view all likes"
  on publication_likes for select
  using (true);

-- Users can insert their own likes
create policy "Users can insert their own likes"
  on publication_likes for insert
  with check (auth.uid() = user_id);

-- Users can delete their own likes
create policy "Users can delete their own likes"
  on publication_likes for delete
  using (auth.uid() = user_id);
