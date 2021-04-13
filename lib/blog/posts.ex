defmodule Blog.Posts do
  alias Blog.{Post, Repo}

  import Ecto.Query

  def create(%{"title" => _title, "content" => _content} = params, user_id) do
    params
    |> Map.put("user_id", user_id)
    |> Post.changeset()
    |> Repo.insert()
  end

  def create(%{"title" => _}, _) do
    {:error, "\"content\" is required"}
  end

  def create(%{"content" => _}, _) do
    {:error, "\"title\" is required"}
  end
end
