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
    field :difficulty, Ecto.Enum, values: [:easy, :medium, :hard], default: :easy
    field :done_image, :string, default: ""
    field :done_today, :boolean, default: false
    field :end_date, :naive_datetime
    field :notification_date, :naive_datetime
    field :notify, Ecto.Enum, values: [:hourly, :daily, :weekly, :monthly]
    field :order_index, :integer, default: 0
    field :status, Ecto.Enum, values: [:done, :canceled, :in_progress], default: :in_progress
    field :times_done, :integer, default: 0
    field :type, Ecto.Enum, values: [:good, :bad]
    field :obvious, :string, default: ""
    field :attractive, :string, default: ""
    field :easy, :string, default: ""
    field :satisfying, :string, default: ""
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  @optionals ~w[done_image difficulty]a
  @required ~w[name description type order_index notification_date notify end_date done_today times_done status user_id]a
  def changeset(habit, attrs, language \\ "en") do
    mix_env = "MIX_ENV" |> System.get_env() |> String.to_atom()

    id =
      case habit do
        %{id: id} -> id
        _ -> nil
      end

    habit
    |> cast(attrs, @optionals ++ @required)
    |> validate_required(@required)
    |> gen_recommendations_and_difficulty(mix_env, language, id)
  end

  @spec gen_recommendations_and_difficulty(
          Ecto.Changeset.t(),
          atom(),
          String.t(),
          String.t() | nil
        ) ::
          Ecto.Changeset.t()
  defp gen_recommendations_and_difficulty(
         %{errors: [], valid?: true} = changeset,
         :prod,
         language,
         nil
       ) do
    changeset
    |> get_prompt()
    |> Jason.encode!()
    |> GPT.ask(language)
    |> case do
      {:ok, gpt_response} ->
        %{
          "difficulty" => difficulty,
          "obvious" => obvious,
          "attractive" => attractive,
          "easy" => easy,
          "satisfying" => satisfying
        } = Jason.decode!(gpt_response)

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

  defp gen_recommendations_and_difficulty(changeset, _mix_env, _language, _id), do: changeset

  defp get_prompt(%{changes: %{name: name, description: description, type: type}}) do
    %{name: name, description: description, type: type}
  end
end
