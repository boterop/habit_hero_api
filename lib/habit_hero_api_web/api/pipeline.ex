defmodule HabitHeroApiWeb.API.Pipeline do
  @moduledoc """
  This module defines a pipeline for authenticating API requests based on an API key.
  """

  alias HabitHeroApiWeb.API.ErrorResponse.InvalidKey

  import Plug.Conn

  @type connection :: Plug.Conn.t()

  def init(options), do: options

  @spec call(conn :: connection(), any()) :: connection()
  def call(conn, _args) do
    api_key = "MIX_ENV" |> System.get_env() |> String.to_atom() |> get_api_key()

    conn
    |> get_req_header("api-key")
    |> valid_key?(api_key)
    |> check_is_valid(conn)
  end

  @spec get_api_key(atom()) :: String.t()
  defp get_api_key(:prod), do: System.get_env("API_KEY")
  defp get_api_key(:dev), do: get_api_key(:prod)
  defp get_api_key(_env), do: System.get_env("TEST_API_KEY")

  @spec valid_key?(key :: list(String.t()), api_key :: String.t()) :: boolean()
  defp valid_key?(["Bearer " <> key], api_key) when is_binary(api_key),
    do: Bcrypt.verify_pass(key, api_key)

  defp valid_key?(_key, _api_key), do: false

  @spec check_is_valid(boolean(), conn :: connection()) :: connection()
  defp check_is_valid(true, conn), do: conn
  defp check_is_valid(false, _conn), do: raise(InvalidKey)
end
