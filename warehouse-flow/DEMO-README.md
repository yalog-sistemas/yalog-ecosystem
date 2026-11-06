# YALog Warehouse Flow — demonstração visual

## Arquivo para teste

Abra `demo-standalone.html` no navegador. O arquivo contém HTML, CSS e motor de workflow incorporados e não requer Supabase nem login.

## Roteiro simples

1. Confira os indicadores na Torre de Controle.
2. Em Operações, crie uma entrada ou saída com referência, transportadora e doca.
3. Em Execução, inicie e conclua as atividades disponíveis. Cada conclusão libera a próxima etapa.
4. Em Ocorrências, registre uma avaria ou atraso e marque sua resolução.
5. Em Auditoria, veja o histórico temporário das ações.

## Limitações

- Dados de demonstração em memória, perdidos ao atualizar a página.
- Nenhuma autenticação, autorização real, integração, RLS ou persistência.
- Não é ambiente de homologação nem produção.
- Ainda requer validação visual em navegador e testes automatizados executados.
- O arquivo SQL revisado não foi aplicado ao Supabase.

## Próximo marco para produção

Homologação isolada, API autenticada, autorização por empresa/unidade, persistência transacional, testes de concorrência e integração com outros módulos.
