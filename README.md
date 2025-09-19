# Fork: Interface em SwiftUI 

Este fork existe para construir a interface do projeto original usando **SwiftUI**, consumindo a API HTTP já existente.


## Capturas de tela
![Screenshot 1](docs/screen1.png)


## Visão Técnica 
- **SwiftUI** para compor telas, estados e navegação.
- **MVVM** para separar responsabilidades: `Model` (dados), `ViewModel` (lógica/estado), `View` (apresentação).
- **Camada de Rede** (HTTP) desacoplada via node que expõe métodos assíncronos.
- **Data Flow** reativo: o `ViewModel` publica estado; as `Views` reagem automaticamente.

## Como o MVVM funciona aqui
- **Model:** estruturas que representam voos, filtros, paginação e respostas da API.
- **ViewModel:** orquestra chamadas HTTP, aplica filtros/ordenação, faz parsing e expõe propriedades publicadas (`@Published`) ou `@StateObject`/`@ObservedObject` para a View.
- **View (SwiftUI):** lê o estado do ViewModel e renderiza listas, detalhes e feedback de carregamento/erro.

## Fluxo de Dados: HTTP → MVVM → UI
1. **Requisição:** o ViewModel chama o `FlightService` (ou cliente HTTP) com parâmetros (origem, destino, ordenação, paginação, etc.).
2. **Transporte:** o serviço monta a URL/endpoint, executa a requisição e recebe JSON.
3. **Parsing:** o serviço decodifica JSON em `Model` (via `Codable`).
4. **Estado:** o ViewModel atualiza propriedades publicadas.
5. **Renderização:** as Views reagem às mudanças e atualizam a UI (listas, indicadores, mensagens).
6. **Ações do Usuário:** interação na View (buscar, ordenar, paginar) chama métodos do ViewModel, reiniciando o ciclo.

## Considerações de Arquitetura
- **Isolamento de Camadas:** View não conhece HTTP; ViewModel não conhece detalhes de UI.
- **Testabilidade:** lógica de ordenação/busca e parsing podem ser testados no ViewModel/Serviço.
- **Erros e Loading:** padronizados via estado do ViewModel para feedback na UI.
- **Extensibilidade:** novos filtros/algoritmos entram no ViewModel/Serviço sem alterar Views.


## Instruções para rodar o app
- **Requisitos:** Xcode 26, Node.js, PostgreSQL 17
- **Backend:** Use npm install no diretório da backend para instalar dependências. Crie uma database com o PSQL. Use o pg-restore para importar o banco de dados provisório no PSQL. Use o exemplo dotenv para preencher um dotfile env — tenha certeza de que os conteúdos de dotenv se alinhem com o seu banco de dados PSQL. Caso não veja o arquivo dotenv pressione: (⌘ + Shift + .) Use npm run para iniciar o servidor, vá para <ipEscolhido>:<portaEscolhida>/health para checar os status do servidor e banco de dados.
- **Backend (Servidor):** Se preferir podes rodar os servidores npm e PSQL em um servidor dedicado, para fazer isso apenas siga as instruções anteriores em seu servidor, vale lembrar que o endereço IP referente à backend na MVVM vai ser o IP local de seu servidor em vez de localhost
- **MVVM:** mantenha a API do projeto original acessível em sua rede; configure a URL da API no app dependendo do endereço que você escolheu. (O projeto está configurado para receber um endereço IPV6, não é proíbido usar localhost mas talvez não vai funcionar) — Existem structs com dados para popular a interface caso queira prototipar sem usar a backend.
- **Execução:** selecione um simulador e rode (⌘R) O target do app é macOS, não rode um simulador iOS.
