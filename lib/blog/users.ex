defmodule Blog.Users do
  alias Blog.{Repo, Sessions, User}

  import Ecto.Query

  def list do
    users =
      User
      |> Repo.all()

    {:ok, users}
  end

  def get(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}

      _ ->
        {:error, "Usuario não existe"}
    end
  end

  def create(params) do
    with {:ok, %User{id: user_id}} <-
           params
           |> User.changeset()
           |> Repo.insert() do
      Sessions.create_token(user_id)
    end
  end

  def delete(id) do
    User
    |> Repo.get(id)
    |> Repo.delete()
  end

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      %User{} = user ->
        {:ok, user}

      _ ->
        {:error, "Usuario não existe"}
    end
  end
end
