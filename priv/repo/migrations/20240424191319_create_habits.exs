defmodule HabitHeroApi.Repo.Migrations.CreateHabits do
  use Ecto.Migration

  def change do
    create table(:habits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :difficulty, :string
      add :type, :string
      add :order_index, :integer
      add :notification_date, :naive_datetime
      add :notify, :string
      add :end_date, :naive_datetime
      add :done_image, :string
      add :done_today, :boolean, default: false, null: false
      add :times_done, :integer
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:habits, [:user_id])
  end
end
