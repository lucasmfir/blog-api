defmodule Blog.SessionsTest do
  use Blog.DataCase, async: true

  alias Blog.{Sessions, Token}

  @default_user_params %{
    "display_name" => "user name",
    "email" => "user@email.com",
    "password" => "123456",
    "image" => "https://imagebucket.com/1"
  }

  describe "login/1" do
    test "when params are valid, returns jwt token" do
      Blog.create_user(@default_user_params)

      %{"email" => email, "password" => password} = @default_user_params
      login_params = %{"email" => email, "password" => password}

      assert {:ok, token, _token_data} = Sessions.login(login_params)
      assert {:ok, _} = Token.verify(token)
    end

    test "when params are not sent or are empty, returns an error" do
      assert {:error, "\"password\" is required"} =
               Sessions.login(%{"email" => "email@email.com"})

      assert {:error, "\"email\" is required"} = Sessions.login(%{"password" => "123456"})

      assert {:error, "\"password\" is not allowed to be empty"} =
               Sessions.login(%{"email" => "email@email.com", "password" => ""})

      assert {:error, "\"email\" is not allowed to be empty"} =
               Sessions.login(%{"email" => "", "password" => "123456"})
    end

    test "when email and password doesnt match, returns an error" do
      Blog.create_user(@default_user_params)

      %{"email" => email, "password" => password} = @default_user_params

      wrong_password_params = %{"email" => email, "password" => "asdfgh"}
      wrong_email_params = %{"email" => "wrongemail@email.com", "password" => password}

      assert {:error, "Campos inválidos"} = Sessions.login(wrong_password_params)
      assert {:error, "Campos inválidos"} = Sessions.login(wrong_email_params)
    end
  end

  describe "create_token/1" do
    test "creates a jwt token for a guiven user_id" do
      user_id = 12

      assert {:ok, token, token_data} = Sessions.create_token(user_id)
      assert {:ok, _token_data} = Token.verify(token)
      assert %{"user_id" => ^user_id} = token_data
    end
  end
end
