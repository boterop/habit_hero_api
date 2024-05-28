defmodule HabitHeroApi.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HabitHeroApi.Account` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some_email_#{System.unique_integer([:positive])}@mail.com"

  @doc """
  Generate a unique user name.
  """
  def unique_user_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: unique_user_name(),
        password: "some password"
      })
      |> HabitHeroApi.Account.create_user()

    user
  end
end
