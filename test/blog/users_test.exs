defmodule Blog.UsersTest do
  use Blog.DataCase, async: true

  alias Blog.{Token, User, Users}
  alias Ecto.Changeset

  import Blog.TestHelpers

  @default_user_params %{
    "display_name" => "user name",
    "email" => "user@email.com",
    "password" => "123456",
    "image" => "https://imagebucket.com/1"
  }

  describe "create/1" do
    test "when params are valid, creates user and returns a token" do
      {:ok, token, _} = Users.create(@default_user_params)

      assert {:ok, token_data} = Token.verify(token)
      assert {:ok, %User{} = user} = Blog.get_user(token_data["user_id"])
      assert @default_user_params["display_name"] == user.display_name
      assert @default_user_params["email"] == user.email
      assert @default_user_params["image"] == user.image
    end

    test "when there is an user with same email, returns an error" do
      Blog.create_user(@default_user_params)
      
      assert {:error, %Changeset{} = changeset} = Users.create(@default_user_params)
      assert "Usuário já existe" == changeset_error_msg(changeset, :email)
    end

    test "when email has ivalid format, returns an error" do
      invalid_email_params = %{@default_user_params | "email" => "@gmail.com"}

      assert {:error, %Changeset{} = changeset} = Blog.create_user(invalid_email_params)
      assert "has invalid format" == changeset_error_msg(changeset, :email)
    end

    test "when display_name is shorter than 8, returns an error" do
      invalid_name_params = %{@default_user_params | "display_name" => "name"}

      assert {:error, %Changeset{} = changeset} = Blog.create_user(invalid_name_params)
      assert "should be at least %{count} character(s)" == changeset_error_msg(changeset, :display_name)
    end

    test "when password is shorter than 6, returns an error" do
      invalid_password_params = %{@default_user_params | "password" => "123"}

      assert {:error, %Changeset{} = changeset} = Blog.create_user(invalid_password_params)
      assert "should be at least %{count} character(s)" == changeset_error_msg(changeset, :password)
    end

    test "when required field is not passed, returns an error" do
      invalid_params = Map.drop(@default_user_params, ["password"])

      assert {:error, %Changeset{} = changeset} = Blog.create_user(invalid_params)
    end
  end

  describe "get/1" do
    setup do
      {:ok, _token, token_data} = Blog.create_user(@default_user_params)

      {:ok, user_id: token_data["user_id"]}
    end

    test "when id is valid, returns an user", %{user_id: user_id} do
      assert {:ok, %User{} = user} = Users.get(user_id)
      assert user.id == user_id
    end

    test "when id is invalid, returns an error", %{user_id: user_id} do
      invalid_id = user_id + 999
      assert {:error, "Usuario não existe"} = Users.get(invalid_id)
    end
  end

  describe "list/0" do
    test "when there are users, returns users" do
      Blog.create_user(@default_user_params)
      Blog.create_user(%{@default_user_params | "email" => "email2@email.com"})
      Blog.create_user(%{@default_user_params | "email" => "email3@email.com"})

      assert {:ok, [%User{} | _tail] = users} = Users.list()
      assert 3 == length(users)
    end

    test "when there is no user, returns an empty list" do
      assert {:ok, []} = Users.list()
    end
  end

  describe "delete/1" do
    test "when is a valid id, deletes user" do
      {:ok, _token, token_data} = Blog.create_user(@default_user_params)

      user_id = token_data["user_id"]

      assert {:ok, _user} = Users.delete(user_id)
      assert {:error, _} = Blog.get_user(user_id)
    end
  end

  describe "get_by_email/1" do
    test "when is a valid email, returns an user" do
      {:ok, _token, _token_data} = Blog.create_user(@default_user_params)

      email = @default_user_params["email"]

      assert {:ok, _user} = Users.get_by_email(email)
    end

    test "when is an invalid email, returns an error" do
      invalid_email = "invalid_email@email.com"

      assert {:error, "Usuario não existe"} = Users.get_by_email(invalid_email)
    end
  end
end
