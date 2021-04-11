defmodule Blog.Users do
  alias Blog.{User, Repo}

  import Ecto.Query

  def show(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}

      _ ->
        {:error, "Usuario não existe"}
    end
  end

  def create(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
