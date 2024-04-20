defmodule HabitHeroApiWeb.UserController do
  use HabitHeroApiWeb, :controller

  alias HabitHeroApi.Account
  alias HabitHeroApi.Account.User
  alias HabitHeroApiWeb.Auth.{ErrorResponse, Guardian}

  action_fallback HabitHeroApiWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         {:ok, _user, token} <- Guardian.create_token(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show_token, user: user, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, %User{} = user, token} ->
        conn
        |> put_status(:ok)
        |> render(:show_token, user: user, token: token)

      _error ->
        raise(ErrorResponse.Unauthorized)
    end
  end
end
