# WF-006 — Contrato de integração (rascunho)

## Descoberta em leitura no Supabase

Funções existentes identificadas: validar_sessao_modulo, validar_handoff_modulo, gerar_handoff_modulo, usuario_autorizado_modulo, validar_sessao_ecosystem, revogar_sessao_modulo. Suas assinaturas e permissões **não foram confirmadas**: consultas de metadados adicionais foram bloqueadas.

## Fluxo de autorização proposto

1. A plataforma emite handoff ao abrir Warehouse Flow.
2. Backend de Warehouse Flow valida o handoff pelo contrato oficial, ainda a confirmar.
3. Backend confirma empresa, módulo ativo, login, perfil, validade e revogação da sessão.
4. Cada comando exige company_id e unit_id autorizados pelo servidor, nunca apenas fornecidos pelo navegador.
5. Todas as escritas de operação/tarefa/evento ocorrem em uma transação; alterações de estado são verificadas no servidor.
6. Integrações usam event_id, source e company_id para deduplicação.

## Critérios de aceite antes de ativar persistência

- Confirmar assinaturas e privilégios das funções de sessão existentes.
- Confirmar cadastro real de unidades e vínculo do usuário à unidade.
- Corrigir o SQL de WF-001: company_id deve ser TEXT, não UUID.
- Validar integridade cruzada de tenant em operações, tarefas e eventos.
- Testar sessão expirada/revogada, usuário inativo, empresa diferente, unidade não autorizada, replay de evento e duas conclusões concorrentes.
- Validar RLS e política de acesso por meio de testes automatizados em homologação.
- Não publicar chaves secretas no frontend e não modificar funções/tabelas dos módulos existentes.

## Estado

Documento de contrato registrado. Nenhuma função, tabela, permissão ou dado de produção foi modificado. Implantação bloqueada até revisão técnica.
