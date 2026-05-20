-- Tabla de tokens de dispositivo para notificaciones push

create extension if not exists "pgcrypto";

create table if not exists device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id),
  device_token text not null,
  platform text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (device_token)
);

create index if not exists device_tokens_user_idx on device_tokens (user_id);
