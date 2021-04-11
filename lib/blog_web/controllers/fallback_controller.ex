defmodule BlogWeb.FallbackController do
  use BlogWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
