defmodule HabitHeroApiWeb.API.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :habit_hero_api,
    module: HabitHeroApiWeb.API.Guardian,
    error_handler: HabitHeroApiWeb.API.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end
