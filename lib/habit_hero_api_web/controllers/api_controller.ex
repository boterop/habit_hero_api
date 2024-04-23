defmodule HabitHeroApiWeb.APIController do
  use HabitHeroApiWeb, :controller

  action_fallback HabitHeroApiWeb.FallbackController

  def health(conn, _params) do
    send_resp(conn, :ok, "")
  end
end
