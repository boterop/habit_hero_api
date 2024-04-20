defmodule HabitHeroApiWeb.API.Guardian do
  use Guardian, otp_app: :habit_hero_api

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_id_provided}

  def resource_from_claims(%{"sub" => id}), do: create_token(%{id: id})

  def resource_from_claims(_claims), do: {:error, :no_id_provided}

  def create_token(%{} = client) do
    {:ok, token, _claims} = encode_and_sign(client)
    {:ok, client, token}
  end

  def create_token(error), do: error
end
