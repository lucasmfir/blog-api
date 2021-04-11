defmodule BlogWeb.UsersView do
  def render("create.json", %{user: user}) do
    %{
      message: "user created",
      user: %{
        id: user.id,
        display_name: user.display_name,
        image: user.image
      }
    }
  end
end
