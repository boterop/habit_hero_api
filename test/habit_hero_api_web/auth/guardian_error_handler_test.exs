defmodule HabitHeroApiWeb.Auth.GuardianErrorHandlerTest do
  use HabitHeroApiWeb.ConnCase

  alias HabitHeroApiWeb.Auth.GuardianErrorHandler

  @opts []

  describe "auth_error/3" do
    test "returns a 401 response with the error type as a JSON body", %{conn: conn} do
      type = :invalid_token
      resp_body = ~s({"error":"#{type}"})
      reason = "The token is invalid"

      %{status: 401, resp_body: ^resp_body} =
        GuardianErrorHandler.auth_error(conn, {type, reason}, @opts)
    end

    test "handles different error types", %{conn: conn} do
      type = :expired_token
      resp_body = ~s({"error":"#{type}"})
      reason = "The token has expired"

      %{status: 401, resp_body: ^resp_body} =
        GuardianErrorHandler.auth_error(conn, {type, reason}, @opts)
    end

    test "converts non-atom error types to string", %{conn: conn} do
      type = "complex_error"
      resp_body = ~s({"error":"#{type}"})
      reason = "A complex scenario"

      %{status: 401, resp_body: ^resp_body} =
        GuardianErrorHandler.auth_error(conn, {type, reason}, @opts)
    end
  end
end
