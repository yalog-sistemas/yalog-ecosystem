# YALog Warehouse Flow — WF-001
Status: arquitetura inicial, sem deploy. Modelo C: híbrido.

## Limites
Módulo independente. Não modificar arquivos de main nem tabelas dos produtos existentes. Integrações por contratos versionados. Plataforma YALog é responsável por identidade/handoff; Warehouse Flow por tarefas e execução; WMS por saldo/estoque; Pátio por check-in, filas e docas.

## Inspeção inicial
yalog-platform: index.html e yalog-platform-theme.css; design system incorporado no HTML.
yalog-gestao-patio: index.html; SDK supabase-js v2; comentário de build indica SSO obrigatório e Core Supabase.
yalog-wms: index.html grande, requer inspeção dirigida antes de reutilização.
As implementações de autenticação, handoff e modelo de dados ainda precisam ser validadas em profundidade.

## Componentes
- UI responsiva: painel, fila de tarefas, mobile, gestão de ocorrências.
- Workflow engine: definição versionada, dependências, transições, SLA.
- API: comandos autenticados e leitura paginada por tenant.
- Event gateway: inbox/outbox, deduplicação, retries, dead letter.
- Adapter layer: manual, importação CSV, API/EDI, conectores WMS/TMS/ERP.
- Persistence: tabelas wf_* com company_id e unit_id, RLS e trilha auditável.

## Estados
planned -> ready -> in_progress -> completed.
Estados alternativos: paused, blocked, cancelled. Transições autorizadas por papel e regras, com eventos imutáveis e timestamps do servidor. Conferência parcial bloqueia apenas handling units afetadas.

## Segurança
Supabase Auth + autorização server-side e RLS por empresa/unidade; nenhuma service_role no navegador. Validar JWT e vínculo module_users antes de operações. Não confiar no company_id enviado pelo cliente sem checar associação. Segredos EDI apenas em backend. Migrations separadas e reversíveis.

## Integração
Evento canônico: event_id, schema_version, tenant_id, unit_id, operation_id, event_type, occurred_at, source, payload, correlation_id. Idempotência com UNIQUE(source,event_id). Inbox/outbox transacionais. Reprocessamento seguro, sem prometer exactly-once de ponta a ponta.

## Critérios para avançar
1. Validar SSO/handoff da plataforma e Core do Pátio.
2. Confirmar contratos e schema Supabase atual antes de migrations.
3. Criar repositório dedicado yalog-warehouse-flow, sem alterar produção.
4. Implementar testes de RLS, transições, concorrência e idempotência.
5. Publicar primeiro em homologação, após revisão.
