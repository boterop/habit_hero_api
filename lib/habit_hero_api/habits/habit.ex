defmodule HabitHeroApi.Habits.Habit do
  @moduledoc """
  Module for defining the schema for the 'habits' table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias HabitHeroApi.AI.GPT

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "habits" do
    field :name, :string
    field :description, :string
    field :difficulty, Ecto.Enum, values: [:easy, :medium, :hard]
    field :done_image, :string, default: ""
    field :done_today, :boolean, default: false
    field :end_date, :naive_datetime
    field :notification_date, :naive_datetime
    field :notify, Ecto.Enum, values: [:hourly, :daily, :weekly, :monthly]
    field :order_index, :integer, default: 0
    field :status, Ecto.Enum, values: [:done, :canceled, :in_progress], default: :in_progress
    field :times_done, :integer, default: 0
    field :type, Ecto.Enum, values: [:good, :bad]
    field :obvious, :string
    field :attractive, :string
    field :easy, :string
    field :satisfying, :string
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  @optionals ~w[done_image]a
  @required ~w[name description type order_index notification_date notify end_date done_today times_done status user_id]a
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, @optionals ++ @required)
    |> validate_required(@required)
    |> gen_recommendations_and_difficulty()
  end

  defp gen_recommendations_and_difficulty(%{errors: [], valid?: true} = changeset) do
    changeset
    |> get_prompt()
    |> Jason.encode!()
    |> GPT.ask()
    |> case do
      {:ok,
       %{
         "difficulty" => difficulty,
         "obvious" => obvious,
         "attractive" => attractive,
         "easy" => easy,
         "satisfying" => satisfying
       }} ->
        changeset
        |> put_change(:difficulty, String.to_atom(difficulty))
        |> put_change(:obvious, obvious)
        |> put_change(:attractive, attractive)
        |> put_change(:easy, easy)
        |> put_change(:satisfying, satisfying)

      {:error, error} ->
        changeset
        |> add_error(:base, error)
    end
  end

  defp gen_recommendations_and_difficulty(changeset), do: changeset

  defp get_prompt(%{changes: %{name: name, description: description, type: type}}) do
    %{name: name, description: description, type: type}
  end
end
