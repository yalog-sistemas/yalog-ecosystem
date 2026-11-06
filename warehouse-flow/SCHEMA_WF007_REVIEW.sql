-- Warehouse Flow WF-007 - isolated schema proposal; DO NOT deploy to production
-- company_id is TEXT in YALog OS, as verified from existing database.
CREATE TABLE public.wf_operations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 company_id text NOT NULL REFERENCES public.empresas(company_id),
 unit_id text NOT NULL,
 reference text NOT NULL,
 direction text NOT NULL CHECK (direction IN ('inbound','outbound')),
 carrier text,
 dock text,
 status text NOT NULL DEFAULT 'planned',
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(id,company_id,unit_id)
);
CREATE TABLE public.wf_tasks (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 operation_id uuid NOT NULL,
 company_id text NOT NULL,
 unit_id text NOT NULL,
 stage text NOT NULL,
 status text NOT NULL DEFAULT 'planned',
 assigned_login text,
 started_at timestamptz,
 completed_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now(),
 FOREIGN KEY(operation_id,company_id,unit_id)
 REFERENCES public.wf_operations(id,company_id,unit_id),
 UNIQUE(id,company_id,unit_id)
);
CREATE TABLE public.wf_task_events (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 task_id uuid NOT NULL,
 company_id text NOT NULL,
 unit_id text NOT NULL,
 actor_login text NOT NULL,
 event_type text NOT NULL,
 occurred_at timestamptz NOT NULL DEFAULT now(),
 FOREIGN KEY(task_id,company_id,unit_id)
 REFERENCES public.wf_tasks(id,company_id,unit_id)
);
CREATE TABLE public.wf_occurrences (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 operation_id uuid NOT NULL,
 company_id text NOT NULL,
 unit_id text NOT NULL,
 category text NOT NULL,
 severity text NOT NULL,
 description text NOT NULL,
 status text NOT NULL DEFAULT 'open',
 created_by_login text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 FOREIGN KEY(operation_id,company_id,unit_id)
 REFERENCES public.wf_operations(id,company_id,unit_id)
);
ALTER TABLE public.wf_operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wf_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wf_task_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wf_occurrences ENABLE ROW LEVEL SECURITY;
-- No client policies or grants: default deny until backend authorization is verified.
