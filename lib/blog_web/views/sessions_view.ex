defmodule BlogWeb.SessionsView do
  def render("login.json", %{token: token}) do
    %{
      token: token
    }
  end
end
