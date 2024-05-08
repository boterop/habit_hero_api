defmodule HabitHeroApiWeb.Auth.Guardian do
  @moduledoc """
  Guardian module for authentication in the HabitHeroApiWeb application.
  """

  use Guardian, otp_app: :habit_hero_api
  alias HabitHeroApi.{Account, Account.User}

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_id_provided}

  def resource_from_claims(%{"sub" => id}) do
    try do
      Account.get_user!(id)
    rescue
      _error -> nil
    end
    |> check_user()
    |> create_token()
  end

  def resource_from_claims(_claims), do: {:error, :no_id_provided}

  @spec authenticate(email :: String.t(), password :: String.t()) ::
          {:ok, User.t(), String.t()} | false
  def authenticate(email, password) do
    with %User{} = user <- Account.get_user_by_email!(email),
         true <- validate_user(user, password) do
      create_token(user)
    end
  end

  @spec create_token(user :: User.t()) :: {:ok, User.t(), String.t()}
  def create_token(%User{} = user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end

  def create_token(error), do: error

  defp validate_user(%{password: password_hash}, password),
    do: Bcrypt.verify_pass(password, password_hash)

  defp check_user(nil), do: {:error, :not_found}
  defp check_user(user), do: user
end
