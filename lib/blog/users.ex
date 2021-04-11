defmodule Blog.Users do
  alias Blog.{User, Repo}

  import Ecto.Query

  def create(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
