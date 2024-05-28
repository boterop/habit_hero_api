[![Coverage Status](https://coveralls.io/repos/github/boterop/habit_hero_api/badge.svg?branch=main)](https://coveralls.io/github/boterop/habit_hero_api?branch=main)

# HabitHeroApi

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
Bcrypt.hash_pwd_salt("api password")
```

use the hash in API_KEY into .env and password in the header Api-Key
e.g.

```elixir
# .env
export API_KEY='$2b$12$fyG7UK5rZ4Xi6JZ9n43AZuuyU8NBpxJ8Px5WZGhluH0YIgnWu/t92'

# Request
headers = %{"Api-Key": "Bearer api password"}
```

For user tokens into Authorization

```elixir
headers = {
  "Api-Key": "Bearer #{result_token}",
  "Authorization": "Bearer #{user_token}"
}
```

## Systemd daemon

```sh
[Unit]
Description="Habits Hero API"
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/user/habit_hero_api_folder
Enviroment=.env
ExecStart=/bin/bash -c 'PATH=/home/user/.asdf/shims:$PATH && ./start.sh >> ../logs/habit_hero_api.log'
Restart=always

[Install]
WantedBy=multi-user.target
```

## Editing

To create a new schema with endpoints run `mix phx.gen.json Accounts User users name:string age:integer` changing <Accounts> <User> <users> [more info](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Json.html)

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
