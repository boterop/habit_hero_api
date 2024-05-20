defmodule HabitHeroApi.Repo.Migrations.AddHabitRecommendations do
  use Ecto.Migration

  def change do
    alter table(:habits) do
      add :obvious, :string
      add :attractive, :string
      add :easy, :string
      add :satisfying, :string
    end
  end
end
