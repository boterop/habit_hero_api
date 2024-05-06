defmodule HabitHeroApiWeb.API.Pipeline do
  import Plug.Conn

  @type connection :: Plug.Conn.t()

  def init(options), do: options

  @spec call(conn :: connection(), any()) :: connection()
  def call(conn, _args) do
    conn
    |> get_req_header("api-key")
    |> is_a_valid_key?()
    |> check_is_valid(conn)
  end

  @spec is_a_valid_key?(key :: String.t()) :: boolean()
  defp is_a_valid_key?(["Bearer " <> key]), do: Bcrypt.verify_pass(key, System.get_env("API_KEY"))
  defp is_a_valid_key?(_key), do: false

  @spec check_is_valid(boolean(), conn :: connection()) :: connection()
  defp check_is_valid(true, conn), do: conn
  defp check_is_valid(false, _conn), do: raise("Invalid API key")
end
