defmodule HabitHeroApi.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "habits" do
    field :description, :string
    field :difficulty, Ecto.Enum, values: [:easy, :medium, :hard]
    field :done_image, :string
    field :done_today, :boolean, default: false
    field :end_date, :naive_datetime
    field :name, :string
    field :notification_date, :naive_datetime
    field :notify, Ecto.Enum, values: [:hourly, :daily, :weekly, :monthly]
    field :order_index, :integer
    field :status, Ecto.Enum, values: [:done, :canceled, :in_progress]
    field :times_done, :integer
    field :type, Ecto.Enum, values: [:good, :bad]
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :description, :difficulty, :type, :order_index, :notification_date, :notify, :end_date, :done_image, :done_today, :times_done, :status])
    |> validate_required([:name, :description, :difficulty, :type, :order_index, :notification_date, :notify, :end_date, :done_image, :done_today, :times_done, :status])
  end
end
