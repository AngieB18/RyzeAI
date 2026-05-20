-- Enable RLS on notifications table
alter table notifications enable row level security;

-- Anyone can view notifications they received
create policy "Users can view their own notifications"
  on notifications for select
  using (auth.uid() = recipient_user_id);

-- Anyone can insert notifications (when they send to others)
create policy "Users can create notifications"
  on notifications for insert
  with check (auth.uid() = sender_user_id);

-- Users can update notifications they received
create policy "Users can update their own notifications"
  on notifications for update
  using (auth.uid() = recipient_user_id)
  with check (auth.uid() = recipient_user_id);
