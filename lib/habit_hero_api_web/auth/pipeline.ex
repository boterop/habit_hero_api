defmodule HabitHeroApiWeb.Auth.Pipeline do
  @moduledoc """
  Pipeline module for Guardian authentication in the HabitHeroApiWeb application.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :habit_hero_api,
    module: HabitHeroApiWeb.Auth.Guardian,
    error_handler: HabitHeroApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader, header_name: "authentication"
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
