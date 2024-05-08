defmodule HabitHeroApiWeb.UserControllerTest do
  use HabitHeroApiWeb.ConnCase

  alias HabitHeroApi.Account.User
  alias HabitHeroApiWeb.Auth.Guardian

  import HabitHeroApi.AccountFixtures

  @create_attrs %{
    email: "some email",
    password: "some password"
  }
  @update_attrs %{
    email: "some updated email",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

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
    test "lists all users", %{conn: conn, user: %User{id: user_id, email: user_email}} do
      conn = get(conn, ~p"/api/users")
      [%{"id" => ^user_id, "email" => ^user_email}] = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      %{"data" => %{"id" => id}} =
        conn
        |> post(~p"/api/users", user: @create_attrs)
        |> json_response(201)

      %{email: email} = @create_attrs

      %{
        "data" => %{
          "id" => ^id,
          "email" => ^email
        }
      } = conn |> get(~p"/api/users/#{id}") |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      %{"data" => %{"id" => ^id}} =
        conn
        |> put(~p"/api/users/#{user}", user: @update_attrs)
        |> json_response(200)

      %{
        "data" => %{
          "id" => ^id,
          "email" => "some updated email"
        }
      } =
        conn
        |> get(~p"/api/users/#{id}")
        |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn, user: %User{id: user_id}} do
      assert conn |> delete(~p"/api/users/#{user_id}") |> response(204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user_id}")
      end
    end
  end

  describe "authenticate" do
    test "sign in", %{conn: conn, user: %User{id: user_id, email: email}} do
      %{"data" => %{"id" => ^user_id, "token" => token}} =
        conn
        |> post(~p"/api/sign-in", email: email, password: "some password")
        |> json_response(200)

      assert is_binary(token)
    end

    test "sign in with invalid password", %{conn: conn, user: %User{email: email}} do
      assert_error_sent 401, fn ->
        post(conn, ~p"/api/sign-in", email: email, password: "wrong password")
      end
    end
  end
end
