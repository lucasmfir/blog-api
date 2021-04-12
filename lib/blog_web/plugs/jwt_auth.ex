defmodule BlogWeb.Plugs.JwtAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_token(conn),
         {:ok, %{user_id: user_id}} <- Blog.Token.verify_and_validate(token) do
      conn
      |> assign(:user_id, user_id)
      |> put_status(200)
    else
      {:error, :missing_token} ->
        unauthorized(conn, "Token não encontrado")

      {:error, _} ->
        unauthorized(conn, "Token expirado ou inválido")
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      [token] when token != nil -> {:ok, token}
      _ -> {:error, :missing_token}
    end
  end

  defp unauthorized(conn, msg) do
    conn
    |> send_resp(:unauthorized, msg)
    |> halt()
  end
end
