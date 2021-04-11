defmodule BlogWeb.UsersController do
  use BlogWeb, :controller

  action_fallback BlogWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Blog.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
