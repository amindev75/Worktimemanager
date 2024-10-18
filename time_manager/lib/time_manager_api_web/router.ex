defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  alias TimeManagerWeb.Plugs.Authenticate

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Pipeline pour les routes nécessitant l'authentification
  pipeline :authenticated do
    plug Authenticate
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/login", SessionController, :login
    delete "/logout", SessionController, :delete

    pipe_through :authenticated

    get "/me", UserController, :me
    resources "/users", UserController, except: [:new, :edit]

    get "/workingtime/:userId/:id", WorkingtimeController, :get_workingtimes_by_id
    post "/workingtime/:userId", WorkingtimeController, :create
    put "/workingtime/:userId/:id", WorkingtimeController, :update
    get "/workingtime/:userId", WorkingtimeController, :get_workingtimes
    resources "/workingtime", WorkingtimeController, only: [:update, :delete]

    get "/clocks/:userId", ClockController, :index
    put "/clocks/:userId/toggle_status", ClockController, :toggle_status

    get "/stats/:userId/worked_days_by_month", StatsController, :calculate_worked_days_by_month
    get "/stats/:userId/calculate_average_hours_worked_by_month", StatsController, :calculate_average_hours_worked_by_month
    get "/stats/:userId/calculate_percentage_working_times_outside_standard_hours", StatsController, :calculate_percentage_working_times_outside_standard_hours
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager_api, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
