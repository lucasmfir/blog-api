defmodule BlogWeb.Router do
  use BlogWeb, :router

  # alias BlogWeb.UsersController

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_auth do
    plug BlogWeb.Plugs.JwtAuth
  end

  scope "/", BlogWeb do
    pipe_through :api

    post "/login", SessionsController, :login

    resources "/users", UsersController, only: [:create]

    pipe_through :jwt_auth

    resources "/users", UsersController, only: [:index, :show, :delete]

    resources "/posts", PostsController, only: [:create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
