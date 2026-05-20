
create extension if not exists "pgcrypto";

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_user_id uuid not null references users(id),
  sender_user_id uuid not null references users(id),
  project_id uuid not null references projects(id),
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists notifications_recipient_idx on notifications (recipient_user_id, created_at desc);
