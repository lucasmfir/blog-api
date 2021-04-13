defmodule BlogWeb.UsersControllerTest do
  use BlogWeb.ConnCase, async: true

  alias Blog.Token

  @default_user_params %{
    "display_name" => "user name",
    "email" => "user@email.com",
    "password" => "123456",
    "image" => "https://imagebucket.com/1"
  }

  describe "create/2" do
    test "when params are valid, create user, return 200 and token", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :create, @default_user_params))
        |> json_response(:created)

      assert %{"token" => _token} = response
    end

    test "when there is an user with same email, returns 400 and an error", %{conn: conn} do
      Blog.create_user(@default_user_params)

      response =
        conn
        |> post(Routes.users_path(conn, :create, @default_user_params))
        |> json_response(:bad_request)

      assert %{"message" => %{"email" => ["Usuário já existe"]}} = response
    end

    test "when email has ivalid format, returns 400 and an error", %{conn: conn} do
      invalid_email_params = %{@default_user_params | "email" => "@gmail.com"}

      response =
        conn
        |> post(Routes.users_path(conn, :create, invalid_email_params))
        |> json_response(:bad_request)

      assert %{"message" => %{"email" => ["has invalid format"]}} = response
    end

    test "when display_name is shorter than 8, returns 400 and an error", %{conn: conn} do
      invalid_name_params = %{@default_user_params | "display_name" => "name"}

      response =
        conn
        |> post(Routes.users_path(conn, :create, invalid_name_params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "display_name" => [
                   "should be at least 8 character(s)"
                 ]
               }
             } = response
    end

    test "when password is shorter than 6, returns 400 and an error", %{conn: conn} do
      invalid_password_params = %{@default_user_params | "password" => "123"}

      response =
        conn
        |> post(Routes.users_path(conn, :create, invalid_password_params))
        |> json_response(:bad_request)

      assert %{"message" => %{"password" => ["should be at least 6 character(s)"]}} = response
    end

    test "when required field is not passed, returns 400 and an error", %{conn: conn} do
      invalid_params = Map.drop(@default_user_params, ["password"])

      response =
        conn
        |> post(Routes.users_path(conn, :create, invalid_params))
        |> json_response(:bad_request)

      assert %{"message" => %{"password" => ["can't be blank"]}} = response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      {:ok, token, token_data} = Blog.create_user(@default_user_params)

      conn = put_req_header(conn, "authorization", token)

      {:ok, conn: conn, user_id: token_data["user_id"]}
    end

    test "when id is valid, returns 200 and an user", %{conn: conn, user_id: user_id} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, user_id))
        |> json_response(:ok)

      assert %{
               "display_name" => _,
               "id" => _,
               "email" => _,
               "image" => _
             } = response
    end

    test "when id is invalid, returns 400 an error", %{conn: conn, user_id: user_id} do
      invalid_id = user_id + 999

      response =
        conn
        |> get(Routes.users_path(conn, :show, invalid_id))
        |> json_response(:bad_request)

      assert %{"message" => "Usuario não existe"} = response
    end

    test "when authorization token is not passed, returns 401 and an error", %{
      conn: conn,
      user_id: user_id
    } do
      conn_with_empty_authorization = put_req_header(conn, "authorization", "")

      empty_authorization_response =
        conn_with_empty_authorization
        |> get(Routes.users_path(conn_with_empty_authorization, :show, user_id))
        |> json_response(:unauthorized)

      assert %{"message" => "Token expirado ou inválido"} = empty_authorization_response

      conn_without_authorization = delete_req_header(conn, "authorization")

      without_authorization_response =
        conn_without_authorization
        |> get(Routes.users_path(conn_without_authorization, :show, user_id))
        |> json_response(:unauthorized)

      assert %{"message" => "Token não encontrado"} = without_authorization_response
    end

    test "when authorization token expired, returns 401 and an error", %{
      conn: conn,
      user_id: user_id
    } do
      {:ok, expired_token, _token_data} =
        Token.generate_and_sign(%{"user_id" => user_id, "exp" => 0})

      conn_with_expired_token = put_req_header(conn, "authorization", expired_token)

      response =
        conn_with_expired_token
        |> get(Routes.users_path(conn_with_expired_token, :show, user_id))
        |> json_response(:unauthorized)

      assert %{"message" => "Token expirado ou inválido"} = response
    end

    test "when authorization token is invalid, returns 401 and an error", %{
      conn: conn,
      user_id: user_id
    } do
      conn_with_invalid_token = put_req_header(conn, "authorization", "123xpto")

      response =
        conn_with_invalid_token
        |> get(Routes.users_path(conn_with_invalid_token, :show, user_id))
        |> json_response(:unauthorized)

      assert %{"message" => "Token expirado ou inválido"} = response
    end
  end

  describe "delete/1" do
    test "when is authenticated, returns 204 and deletes user", %{conn: conn} do
      {:ok, token, token_data} = Blog.create_user(@default_user_params)

      conn
      |> put_req_header("authorization", token)
      |> delete(Routes.users_path(conn, :delete, token_data["user_id"]))
      |> response(:no_content)
    end
  end
end
