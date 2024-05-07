defmodule HabitHeroApiWeb.HabitControllerTest do
  use HabitHeroApiWeb.ConnCase

  import HabitHeroApi.HabitsFixtures

  alias HabitHeroApi.Habits.Habit

  @create_attrs %{
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
    type: :good
  }
  @update_attrs %{
    description: "some updated description",
    difficulty: :medium,
    done_image: "some updated done_image",
    done_today: false,
    end_date: ~N[2024-04-24 19:13:00],
    name: "some updated name",
    notification_date: ~N[2024-04-24 19:13:00],
    notify: :daily,
    order_index: 43,
    status: :canceled,
    times_done: 43,
    type: :bad
  }
  @invalid_attrs %{description: nil, difficulty: nil, done_image: nil, done_today: nil, end_date: nil, name: nil, notification_date: nil, notify: nil, order_index: nil, status: nil, times_done: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all habits", %{conn: conn} do
      conn = get(conn, ~p"/api/habits")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create habit" do
    test "renders habit when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/habits", habit: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/habits/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "difficulty" => "easy",
               "done_image" => "some done_image",
               "done_today" => true,
               "end_date" => "2024-04-23T19:13:00",
               "name" => "some name",
               "notification_date" => "2024-04-23T19:13:00",
               "notify" => "hourly",
               "order_index" => 42,
               "status" => "done",
               "times_done" => 42,
               "type" => "good"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/habits", habit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update habit" do
    setup [:create_habit]

    test "renders habit when data is valid", %{conn: conn, habit: %Habit{id: id} = habit} do
      conn = put(conn, ~p"/api/habits/#{habit}", habit: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/habits/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "difficulty" => "medium",
               "done_image" => "some updated done_image",
               "done_today" => false,
               "end_date" => "2024-04-24T19:13:00",
               "name" => "some updated name",
               "notification_date" => "2024-04-24T19:13:00",
               "notify" => "daily",
               "order_index" => 43,
               "status" => "canceled",
               "times_done" => 43,
               "type" => "bad"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, habit: habit} do
      conn = put(conn, ~p"/api/habits/#{habit}", habit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete habit" do
    setup [:create_habit]

    test "deletes chosen habit", %{conn: conn, habit: habit} do
      conn = delete(conn, ~p"/api/habits/#{habit}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/habits/#{habit}")
      end
    end
  end

  defp create_habit(_) do
    habit = habit_fixture()
    %{habit: habit}
  end
end
