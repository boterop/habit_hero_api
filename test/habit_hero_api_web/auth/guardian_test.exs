defmodule HabitHeroApiWeb.Auth.GuardianTest do
  use ExUnit.Case, async: true

  import HabitHeroApi.AccountFixtures

  alias Ecto.Adapters.SQL.Sandbox
  alias HabitHeroApi.Account.User
  alias HabitHeroApiWeb.Auth.Guardian

  setup do
    :ok = Sandbox.checkout(HabitHeroApi.Repo)
    {:ok, user: user_fixture()}
  end

  describe "subject_for_token/2" do
    test "returns {:ok, subject} when id is provided" do
      user = %{id: 123}
      result = Guardian.subject_for_token(user, %{})
      assert result == {:ok, "123"}
    end

    test "returns {:error, :no_id_provided} when id is not provided" do
      result = Guardian.subject_for_token(%{}, %{})
      assert result == {:error, :no_id_provided}
    end
  end

  describe "resource_from_claims/1" do
    test "returns user when valid sub is provided", %{user: %{id: user_id}} do
      {:ok, %User{id: ^user_id}, token} =
        %{}
        |> Map.put("sub", to_string(user_id))
        |> Guardian.resource_from_claims()

      assert is_binary(token)
    end

    test "with no existing user" do
      {:error, :not_found} =
        %{}
        |> Map.put("sub", to_string("no_existing_id"))
        |> Guardian.resource_from_claims()
    end

    test "returns {:error, :no_id_provided} when sub is not provided" do
      {:error, :no_id_provided} = Guardian.resource_from_claims(%{})
    end
  end

  describe "authenticate/2" do
    test "returns {:ok, user, token} when valid credentials are provided", %{
      user: %{id: id, email: email}
    } do
      password = "some password"
      {:ok, auth_user, token} = Guardian.authenticate(email, password)
      %User{id: ^id, email: ^email} = auth_user
      assert is_binary(token)
    end

    test "returns error when invalid credentials are provided", %{user: %{email: email}} do
      password = "wrong_password"
      false = Guardian.authenticate(email, password)
    end
  end

  describe "create_token/1" do
    test "returns {:ok, user, token} when user is provided", %{
      user: %{id: id, email: email} = user
    } do
      {:ok, auth_user, token} = Guardian.create_token(user)
      %User{id: ^id, email: ^email} = auth_user
      assert is_binary(token)
    end

    test "returns error when error is provided" do
      :no_user = Guardian.create_token(:no_user)
    end
  end
end
