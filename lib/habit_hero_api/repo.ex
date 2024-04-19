defmodule HabitHeroApi.Repo do
  use Ecto.Repo,
    otp_app: :habit_hero_api,
    adapter: Ecto.Adapters.Postgres
end
