# WF-007 — Plano de homologação e segurança

## Estado
SCHEMA_WF007_REVIEW.sql é um artefato de revisão, não uma migração aplicada. Não executar no projeto de produção sem validação.

## Testes obrigatórios
1. **Tenant**: operação de empresa A não pode ser consultada, alterada ou associada a tarefa da empresa B.
2. **Unidade**: login autorizado na unidade X não acessa dados da unidade Y.
3. **Sessão**: handoff inválido, expirado ou revogado retorna acesso negado.
4. **Perfil**: usuário somente consulta não inicia, bloqueia nem conclui tarefa.
5. **Transições**: não concluir tarefa planejada, não iniciar sem dependência concluída.
6. **Concorrência**: dois operadores tentando concluir simultaneamente produzem uma única conclusão auditável.
7. **Ocorrências**: categoria, severidade, responsável e histórico persistem após nova sessão.
8. **Eventos**: reenvio com mesma chave de origem não duplica efeitos.
9. **Falhas**: erro durante transação reverte tarefa e evento conjuntamente.
10. **Compatibilidade**: nenhum objeto preexistente de WMS, Pátio, Radar ou Faturamento é alterado.

## Dependências ainda abertas
- Validar assinatura/segurança das funções validar_sessao_modulo e validar_handoff_modulo.
- Confirmar vínculo entre empresa, unidade e usuário operacional.
- Projetar API autenticada no backend, sem chave service_role no navegador.
- Definir política de RLS por modelo de autorização validado.
- Validar SQL em ambiente de homologação isolado antes de publicar.

## Limites do SQL atual
O esquema ainda não contém engine transacional, políticas RLS de leitura/escrita, tabela de integrações inbox/outbox, checks completos de status, nem estratégia de migração. Não representa uma implantação final.
