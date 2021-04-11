defmodule BlogWeb.UsersView do
  def render("index.json", %{users: users}) do
    users_view(users)
  end

  def render("show.json", %{user: user}) do
    user_view(user)
  end

  def render("create.json", %{user: user}) do
    %{
      message: "user created",
      user: user_view(user)
    }
  end

  defp user_view(user) do
    %{
      id: user.id,
      display_name: user.display_name,
      email: user.email,
      image: user.image
    }
  end

  defp users_view(users), do: Enum.map(users, &user_view(&1))
end
