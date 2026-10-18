-- Try Out TKA Matematika SDN Pondok Bambu 04
-- Supabase Dashboard > SQL Editor > New query. Ganti email guru sebelum menjalankan bagian policy SELECT.
create table if not exists public.tka_attempts (
  id bigint generated always as identity primary key,
  student_name text not null check (length(trim(student_name)) between 1 and 80),
  student_class text not null check (length(trim(student_class)) between 1 and 20),
  student_no text,
  student_gender text,
  package_name text not null default 'Try Out TKA Matematika SD',
  school_name text not null default 'SDN Pondok Bambu 04',
  total_questions integer not null default 30 check (total_questions = 30),
  correct_count integer not null check (correct_count between 0 and 30),
  wrong_count integer not null check (wrong_count between 0 and 30),
  blank_count integer not null check (blank_count between 0 and 30),
  score integer not null check (score between 0 and 100),
  earned_points integer not null default 0 check (earned_points between 0 and 50),
  max_points integer not null default 50 check (max_points = 50),
  answers jsonb not null check (jsonb_typeof(answers) = 'array'),
  marked_questions jsonb not null default '[]'::jsonb,
  question_order jsonb not null default '[]'::jsonb,
  time_limit_seconds integer not null default 4500,
  time_used_seconds integer not null default 0,
  time_expired boolean not null default false,
  submitted_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.tka_attempts enable row level security;
-- Siswa hanya dapat INSERT; tidak dapat membaca/mengubah/menghapus hasil.
drop policy if exists "public can submit attempts" on public.tka_attempts;
create policy "public can submit attempts" on public.tka_attempts
  for insert to anon, authenticated
  with check (length(trim(student_name)) between 1 and 80 and length(trim(student_class)) between 1 and 20 and total_questions = 30 and score between 0 and 100 and jsonb_typeof(answers) = 'array');
-- kalamania22@gmail.com dengan email akun guru Supabase Auth.
drop policy if exists "teachers can read attempts" on public.tka_attempts;
create policy "teachers can read attempts" on public.tka_attempts
  for select to authenticated using ((auth.jwt() ->> 'email') = 'kalamania22@gmail.com');
grant insert on public.tka_attempts to anon, authenticated;
grant select on public.tka_attempts to authenticated;
