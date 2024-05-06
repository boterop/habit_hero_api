defmodule HabitHeroApiWeb.UserJSON do
  alias HabitHeroApi.Account.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}), do: %{data: data(user)}

  def show_token(%{user: user, token: token}), do: %{data: data(user, token)}

  defp data(user, token \\ nil)

  defp data(%User{id: id, email: email}, token) do
    data = %{
      id: id,
      email: email
    }

    if token, do: Map.merge(data, %{token: token}), else: data
  end
end
