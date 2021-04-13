# Blog API

API para cadastro usuários e seus posts

## Versões

O projeto foi criado com as seguintes versões de Elixir e Erlang:

- erlang: 22.2.1
- elixir: 1.10.4

## Instalação

- Siga as instruções para de acordo com seu sistema operacional: [elixir-lang.org](https://elixir-lang.org/install.html)

- Caso esteja utilizando o `asdf`como gerenciador de versões do `elixir` e `erlang` apenas execute o comando abaixo:

```sh
asdf install
```

- Crie o arquivo de configurações do ambiente de desenvolvimento, na pasta `/config`, execute o segunte comando:

```sh
cp dev.exs.example dev.exs 
```

- Ajuste as configurações do seu banco local no arquivo `dev.exs`

- Baixe as dependências com o comando:

```sh
mix deps.get
```

## Execução

Para execução do projeto, execute o comando:

```sh
mix phx.server
```

## Testes

Para execução dos testes do projeto, execute o comando:

```sh
mix test
```

## Considerações

- Com finalidade de facilitar testar o uso da autenticação, o token tem tempo de expiração de 2 minutos.
- Como o projeto é apenas um projeto de estudos, as configurações de assinatura do JWT é comum para qualquer ambiente que estiver sendo executado.
- É entendido que todas as tabelas tenham os campos `created_at` e `updated_at`, e esses campos na tabela de `posts`podem ser substitutas do proposto no exercício `published` e `updated`.
