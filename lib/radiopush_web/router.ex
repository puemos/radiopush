defmodule RadiopushWeb.Router do
  use RadiopushWeb, :router

  import RadiopushWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RadiopushWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RadiopushWeb.Telemetry
    end
  end

  ## Routes

  scope "/", RadiopushWeb.Pages do
    pipe_through [:browser]

    live "/legal", Legal
  end

  scope "/", RadiopushWeb.Pages do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/", Landing
  end

  scope "/", RadiopushWeb.Pages do
    pipe_through [:browser, :require_authenticated_user]

    live "/home", Home
    live "/channels", Channels
    live "/explore", Explore
    live "/c/:name", Channel
  end

  ## Authentication routes

  scope "/", RadiopushWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/auth/:provider", UserAuthorizationController, :authorize
    get "/auth/:provider/callback", UserAuthenticationController, :authenticate
  end

  scope "/", RadiopushWeb do
    pipe_through [:browser]

    get "/users/log_out", UserSessionController, :delete
  end
end
