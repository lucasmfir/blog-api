defmodule Blog.PostsTest do
  use Blog.DataCase, async: true

  alias Blog.{Post, Posts}

  @default_user_params %{
    "display_name" => "user name",
    "email" => "user@email.com",
    "password" => "123456",
    "image" => "https://imagebucket.com/1"
  }

  @default_post_params %{
    "title" => "post title",
    "content" => "Bacon ipsum dolor amet spare ribs prosciutto pork chop pork belly."
  }

  describe "create/1" do
    setup do
      {:ok, _token, %{"user_id" => user_id}} = Blog.create_user(@default_user_params)

      {:ok, user_id: user_id}
    end

    test "when params are valid, it creates a post", %{user_id: user_id} do
      assert {:ok, %Post{} = post} = Posts.create(@default_post_params, user_id)
      assert @default_post_params["title"] == post.title
      assert @default_post_params["content"] == post.content
      assert user_id == post.user_id
    end

    test "when params are missing, it returns an error", %{user_id: user_id} do
      missing_title_params = Map.drop(@default_post_params, ["title"])
      missing_content_params = Map.drop(@default_post_params, ["content"])

      assert {:error, "\"title\" is required"} = Posts.create(missing_title_params, user_id)
      assert {:error, "\"content\" is required"} = Posts.create(missing_content_params, user_id)
    end
  end
end
