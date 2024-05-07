defmodule HabitHeroApiWeb.HabitJSON do
  alias HabitHeroApi.Habits.Habit

  @doc """
  Renders a list of habits.
  """
  def index(%{habits: habits}) do
    %{data: for(habit <- habits, do: data(habit))}
  end

  @doc """
  Renders a single habit.
  """
  def show(%{habit: habit}) do
    %{data: data(habit)}
  end

  defp data(%Habit{} = habit) do
    %{
      id: habit.id,
      name: habit.name,
      description: habit.description,
      difficulty: habit.difficulty,
      type: habit.type,
      order_index: habit.order_index,
      notification_date: habit.notification_date,
      notify: habit.notify,
      end_date: habit.end_date,
      done_image: habit.done_image,
      done_today: habit.done_today,
      times_done: habit.times_done,
      status: habit.status
    }
  end
end
