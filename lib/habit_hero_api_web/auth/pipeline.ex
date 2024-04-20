defmodule HabitHeroApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :habit_hero_api,
    module: HabitHeroApiWeb.Auth.Guardian,
    error_handler: HabitHeroApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end
