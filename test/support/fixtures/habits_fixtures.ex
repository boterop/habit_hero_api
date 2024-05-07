defmodule HabitHeroApi.HabitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HabitHeroApi.Habits` context.
  """
  import HabitHeroApi.AccountFixtures

  @doc """
  Generate a habit.
  """
  def habit_fixture(attrs \\ %{}) do
    %{id: user_id} = user_fixture()

    {:ok, habit} =
      attrs
      |> Enum.into(%{
        description: "some description",
        difficulty: :easy,
        done_image: "some done_image",
        done_today: true,
        end_date: ~N[2024-04-23 19:13:00],
        name: "some name",
        notification_date: ~N[2024-04-23 19:13:00],
        notify: :hourly,
        order_index: 42,
        status: :done,
        times_done: 42,
        type: :good,
        user_id: user_id
      })
      |> HabitHeroApi.Habits.create_habit()

    habit
  end
end
