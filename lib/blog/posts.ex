defmodule Blog.Posts do
  alias Blog.{Post, Repo}

  import Ecto.Query

  def create(params, user_id) do
    params
    |> Map.put("user_id", user_id)
    |> Post.changeset()
    |> Repo.insert()
  end
end
