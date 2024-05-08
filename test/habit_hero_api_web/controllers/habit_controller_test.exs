defmodule HabitHeroApiWeb.HabitControllerTest do
  use HabitHeroApiWeb.ConnCase

  alias HabitHeroApi.Habits.Habit
  alias HabitHeroApiWeb.Auth.Guardian

  import HabitHeroApi.{AccountFixtures, HabitsFixtures}

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
  @invalid_attrs %{
    description: nil,
    difficulty: nil,
    done_image: nil,
    done_today: nil,
    end_date: nil,
    name: nil,
    notification_date: nil,
    notify: nil,
    order_index: nil,
    status: nil,
    times_done: nil,
    type: nil,
    user_id: nil
  }

  setup %{conn: conn} do
    api_key = "test_api_key"

    {:ok, user, user_token} = user_fixture() |> Guardian.create_token()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("api-key", "Bearer #{api_key}")
      |> put_req_header("authentication", "Bearer #{user_token}")

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all habits", %{conn: conn} do
      %{"data" => []} =
        conn
        |> get(~p"/api/habits")
        |> json_response(200)
    end

    test "lists habits user", %{conn: conn} do
      %{id: habit_id, user_id: user_id} = habit_fixture()

      %{"data" => [%{"id" => ^habit_id}]} =
        conn
        |> get("/api/users/#{user_id}/habits")
        |> json_response(200)
    end
  end

  describe "create habit" do
    test "renders habit when data is valid", %{conn: conn, user: %{id: user_id}} do
      create_attrs = Map.put(@create_attrs, :user_id, user_id)

      %{"data" => %{"id" => id}} =
        conn
        |> post(~p"/api/habits", habit: create_attrs)
        |> json_response(201)

      %{
        "data" => %{
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
        }
      } = conn |> get(~p"/api/habits/#{id}") |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/habits", habit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update habit" do
    setup [:create_habit]

    test "renders habit when data is valid", %{conn: conn, habit: %Habit{id: id} = habit} do
      %{"data" => %{"id" => ^id}} =
        conn
        |> put(~p"/api/habits/#{habit}", habit: @update_attrs)
        |> json_response(200)

      %{
        "data" => %{
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
        }
      } = conn |> get(~p"/api/habits/#{id}") |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn, habit: habit} do
      conn = put(conn, ~p"/api/habits/#{habit}", habit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete habit" do
    setup [:create_habit]

    test "deletes chosen habit", %{conn: conn, habit: habit} do
      assert conn |> delete(~p"/api/habits/#{habit}") |> response(204)

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
