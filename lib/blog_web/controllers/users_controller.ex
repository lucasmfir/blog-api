defmodule BlogWeb.UsersController do
  use BlogWeb, :controller

  action_fallback BlogWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Blog.show_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    with {:ok, user} <- Blog.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _user} <- Blog.delete_user(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
