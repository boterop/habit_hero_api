defmodule HabitHeroApiWeb.Auth.Guardian do
  use Guardian, otp_app: :habit_hero_api

  def subject_for_token(%{token: token}, _claims) do
    is_valid? = token == System.get_env("API_KEY")
    {:ok, is_valid?}
  end

  def subject_for_token(_, _), do: {:error, :no_token_provided}

  def resource_from_claims(%{"is_valid?" => true}), do: {:ok, true}
  def resource_from_claims(_claims), do: {:error, false}
end
