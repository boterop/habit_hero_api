defmodule HabitHeroApiWeb.API.PipelineTest do
  use HabitHeroApiWeb.ConnCase

  import Mock

  setup %{conn: conn} do
    api_key = "test_api_key"

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("api-key", "Bearer #{api_key}")

    {:ok, conn: conn}
  end

  describe "in prod" do
    test "call pipeline", %{conn: conn} do
      with_mock(System, [:passthrough],
        get_env: fn
          "MIX_ENV" -> "prod"
          "API_KEY" -> "prod_key"
          key -> key
        end
      ) do
        assert System.get_env("MIX_ENV") == "prod"

        assert_error_sent 401, fn ->
          get(conn, ~p"/api/health")
        end
      end
    end
  end

  describe "in test" do
    test "call pipeline", %{conn: conn} do
      assert System.get_env("MIX_ENV") == "test"

      conn
      |> get(~p"/api/health")
      |> response(200)
    end

    test "call pipeline with invalid header", %{conn: conn} do
      assert System.get_env("MIX_ENV") == "test"

      assert_error_sent 401, fn ->
        conn
        |> put_req_header("api-key", "invalid_key")
        |> get(~p"/api/health")
      end
    end
  end
end
