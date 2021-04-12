defmodule BlogWeb.PostsController do
  use BlogWeb, :controller

  action_fallback BlogWeb.FallbackController

  def create(conn, params) do
    user_id = conn.assigns.user_id

    with {:ok, post} <- Blog.create_post(params, user_id) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end
end
