defmodule BlogWeb.SessionsController do
  use BlogWeb, :controller

  action_fallback BlogWeb.FallbackController

  def login(conn, params) do
    with {:ok, token, _token_data} <- Blog.login(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
end
