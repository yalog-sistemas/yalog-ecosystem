-- WF-001: DRAFT / NÃO EXECUTAR EM PRODUÇÃO SEM REVISÃO DE TENANCY E RLS
-- Requer pgcrypto. company_id/unit_id são UUIDs internos a mapear com a plataforma.
create table if not exists public.wf_operations (
 id uuid primary key default gen_random_uuid(),
 company_id uuid not null,
 unit_id uuid not null,
 direction text not null check (direction in ('inbound','outbound')),
 external_ref text,
 status text not null default 'planned' check (status in ('planned','active','completed','cancelled')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists wf_operations_tenant_idx on public.wf_operations(company_id,unit_id,status);
create table if not exists public.wf_tasks (
 id uuid primary key default gen_random_uuid(),
 operation_id uuid not null references public.wf_operations(id),
 company_id uuid not null,
 unit_id uuid not null,
 stage text not null check(stage in ('gate','receiving','inbound_check','putaway','picking','outbound_check','palletizing','shipping','loading')),
 status text not null default 'planned' check(status in ('planned','ready','in_progress','paused','blocked','completed','cancelled')),
 assigned_to uuid,
 started_at timestamptz,
 completed_at timestamptz,
 created_at timestamptz not null default now()
);
create index if not exists wf_tasks_queue_idx on public.wf_tasks(company_id,unit_id,status,stage);
create table if not exists public.wf_task_events (
 id uuid primary key default gen_random_uuid(),
 task_id uuid not null references public.wf_tasks(id),
 company_id uuid not null,
 actor_id uuid,
 event_type text not null,
 details jsonb not null default '{}'::jsonb,
 occurred_at timestamptz not null default now()
);
create table if not exists public.wf_inbox (
 id uuid primary key default gen_random_uuid(),
 company_id uuid not null,
 source text not null,
 external_event_id text not null,
 payload jsonb not null,
 status text not null default 'pending',
 received_at timestamptz not null default now(),
 unique(company_id,source,external_event_id)
);
create table if not exists public.wf_outbox (
 id uuid primary key default gen_random_uuid(),
 company_id uuid not null,
 event_type text not null,
 payload jsonb not null,
 status text not null default 'pending',
 attempts integer not null default 0,
 created_at timestamptz not null default now()
);
-- Bloquear acesso cliente até políticas definitivas serem validadas.
alter table public.wf_operations enable row level security;
alter table public.wf_tasks enable row level security;
alter table public.wf_task_events enable row level security;
alter table public.wf_inbox enable row level security;
alter table public.wf_outbox enable row level security;
-- Nenhuma policy de acesso foi criada intencionalmente: default deny.
-- Revisão obrigatória: chaves compostas/trigger para impedir company_id divergente
-- entre tasks, events e operations; transições somente por RPC autenticada.
