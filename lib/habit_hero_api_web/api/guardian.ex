defmodule HabitHeroApiWeb.API.Guardian do
  use Guardian, otp_app: :habit_hero_api

  def subject_for_token(%{name: name}, _claims) do
    sub = to_string(name)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_name_provided}

  def resource_from_claims(%{"sub" => name}), do: create_token(%{name: name})

  def resource_from_claims(_claims), do: {:error, :no_name_provided}

  def create_token(%{} = client) do
    {:ok, token, _claims} = encode_and_sign(client)
    {:ok, client, token}
  end

  def create_token(error), do: error
end
