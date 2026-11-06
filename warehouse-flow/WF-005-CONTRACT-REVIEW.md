# WF-005 — Revisão de contratos

Análise somente leitura do projeto Supabase yalog-os em 2026-11-05.

- empresas.company_id: TEXT, não UUID.
- company_installations: installation_id UUID e company_id TEXT.
- module_users: company_id TEXT, modulo TEXT, login TEXT, perfil TEXT, ativo BOOLEAN.
- module_sessions: token TEXT, company_id TEXT, login TEXT, modulo TEXT, expires_at, revoked_at.
- platform_modules: module_id TEXT, status TEXT, execution_url TEXT.

O SQL preliminar DATA_MODEL.sql usa um tipo incorreto para company_id e NÃO deve ser executado. O esquema revisado deve usar company_id TEXT, isolamento de empresa/unidade e vínculos compostos entre operações, tarefas e eventos.

A autenticação deve reutilizar as sessões da plataforma com validação no servidor. Acesso direto do navegador ao banco permanece bloqueado até revisão do contrato de handoff e testes de autorização. Nenhuma alteração de banco foi realizada nesta etapa.
