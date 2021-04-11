defmodule BlogWeb.PostsView do
  def render("create.json", %{post: post}) do
    post_view(post)
  end

  defp post_view(post) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      user_id: post.user_id
    }
  end
end
