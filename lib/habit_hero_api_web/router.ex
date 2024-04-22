defmodule HabitHeroApiWeb.Router do
  use HabitHeroApiWeb, :router
  use Plug.ErrorHandler

  @scope "/api"

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn
    |> json(%{errors: message})
    |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HabitHeroApiWeb.API.Pipeline
  end

  pipeline :auth do
    plug HabitHeroApiWeb.Auth.Pipeline
  end

  scope @scope, HabitHeroApiWeb do
    pipe_through :api
    post "/sign_in", UserController, :sign_in
    post "/sign_out", UserController, :create
  end

  scope "#{@scope}/users", HabitHeroApiWeb do
    pipe_through [:api, :auth]
    resources "/", UserController
  end

  scope "#{@scope}/habits", HabitHeroApiWeb do
    pipe_through [:api, :auth]
  end

  scope "#{@scope}/health", HabitHeroApiWeb do
    pipe_through :api
    get "/", APIController, :health
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
