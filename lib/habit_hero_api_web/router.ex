defmodule HabitHeroApiWeb.Router do
  use HabitHeroApiWeb, :router

  @scope "/api"

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope @scope, HabitHeroApiWeb do
    pipe_through :api
  end

  scope "#{@scope}/users", HabitHeroApiWeb do
    pipe_through :api
    resources "/", UserController
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:habit_hero_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HabitHeroApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
