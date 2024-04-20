# HabitHeroApi

[[__TOC__]]

## Set up

To start your Phoenix server:

- Create _.env_ file from _.env.example_
- Edit _.env_ with your data
- Run `source .env` to sync environment variables
- Run `mix setup` to install and setup dependencies
- Run `mix ecto.create` to create database
- Run `mix ecto.migrate` to create tables
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you use [`localhost:4000`](http://localhost:4000) as an API.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### How to use

After [setting up the project](#set-up) you'll need to create an Api-Key, run into the root folder `iex -S mix phx.server` and then

```elixir
HabitHeroApiWeb.API.Guardian.create_token(%{name: "client_name"})
```

use the result token in the header Api-Key
e.g.

```elixir
headers = %{"Api-Key": "Bearer #{result_token}"}
```

For user tokens into Authorization

```elixir
headers = {
  "Api-Key": "Bearer #{result_token}",
  "Authorization": "Bearer #{user_token}"
}
```

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
