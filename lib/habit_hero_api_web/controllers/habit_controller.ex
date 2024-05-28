defmodule HabitHeroApiWeb.HabitController do
  use HabitHeroApiWeb, :controller

  alias HabitHeroApi.Habits
  alias HabitHeroApi.Habits.Habit

  action_fallback HabitHeroApiWeb.FallbackController

  def index(conn, _params) do
    habits = Habits.list_habits()
    render(conn, :index, habits: habits)
  end

  def create(conn, %{"habit" => habit_params}) do
    language = get_req_header(conn, "language")

    language = if language == [], do: "en", else: language |> List.first()

    with {:ok, %Habit{} = habit} <- Habits.create_habit(habit_params, language) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/habits/#{habit}")
      |> render(:show, habit: habit)
    end
  end

  def upload_image(conn, %{"id" => id, "base64_image" => image}) do
    new_habit = %{"done_image" => "image/#{id}"}

    with :ok <- Image.save_base64_image(id, image),
         {:ok, %Habit{} = habit} <- update(conn, %{"id" => id, "habit" => new_habit}) do
      render(conn, :show, habit: habit)
    end
  end

  def show(conn, %{"id" => id}) do
    habit = Habits.get_habit!(id)
    render(conn, :show, habit: habit)
  end

  def show_by_user(conn, %{"user_id" => user_id}) do
    habits = Habits.list_user_habits(user_id)
    render(conn, :index, habits: habits)
  end

  def update(conn, %{"id" => id, "habit" => habit_params}) do
    habit = Habits.get_habit!(id)

    with {:ok, %Habit{} = habit} <- Habits.update_habit(habit, habit_params) do
      render(conn, :show, habit: habit)
    end
  end

  def delete(conn, %{"id" => id}) do
    habit = Habits.get_habit!(id)

    with {:ok, %Habit{}} <- Habits.delete_habit(habit) do
      send_resp(conn, :no_content, "")
    end
  end
end
