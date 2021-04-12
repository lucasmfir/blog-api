defmodule BlogWeb.UsersController do
  use BlogWeb, :controller

  action_fallback BlogWeb.FallbackController

  def index(conn, _params) do
    with {:ok, users} <- Blog.list_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Blog.get_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    with {:ok, token, _token_data} <- Blog.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token)
    end
  end

  def delete(conn, _params) do
    id = conn.assigns.user_id

    with {:ok, _user} <- Blog.delete_user(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
