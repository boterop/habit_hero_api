defmodule HabitHeroApiWeb.ImageController do
  use HabitHeroApiWeb, :controller

  action_fallback HabitHeroApiWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, image} <- Image.get_image(id) do
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, image)
    end
  end
end
