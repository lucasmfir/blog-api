defmodule Blog.UsersTest do
  use Blog.DataCase, async: true

  alias Blog.{Token, User, Users}

  @default_user_params %{
    "display_name" => "user name",
    "email" => "user@email.com",
    "password" => "123456",
    "image" => "https://imagebucket.com/1"
  }

  describe "create/1" do
    test "when params are valid, creates user and returns a token" do
      {:ok, token, _} = Blog.create_user(@default_user_params)

      assert {:ok, token_data} = Token.verify(token)
      assert {:ok, %User{} = user} = Blog.get_user(token_data["user_id"])
      assert @default_user_params["display_name"] == user.display_name
      assert @default_user_params["email"] == user.email
      assert @default_user_params["image"] == user.image
    end
  end

  describe "get/1" do
    # test "when id is valid, returns an user" do
    #   {:ok, userBlog.create()

    # end
  end
end
