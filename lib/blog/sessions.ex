defmodule Blog.Sessions do
  alias Blog.{Token, User, Users, Post, Repo}

  import Ecto.Query

  @signer Application.get_env(:joken, :default_signer)
  @time_to_expirate 60 * 2
  # @time_to_expirate 15

  def login(params) do
    {email, password} = extract_login_params(params)

    do_login(email, password)
  end

  defp do_login(_email, ""), do: {:error, "\"password\" is not allowed to be empty"}

  defp do_login(_email, nil), do: {:error, "\"password\" is required"}

  defp do_login("", _password), do: {:error, "\"email\" is not allowed to be empty"}

  defp do_login(nil, _password), do: {:error, "\"email\" is required"}

  defp do_login(email, password) do
    with {:ok, %User{id: user_id, password: user_password}} <- Users.get_by_email(email),
         true <- valid_password?(password, user_password) do
      create_token(user_id)
    else
      _ ->
        {:error, "Campos inválidos"}
    end
  end

  defp extract_login_params(params) do
    email = Map.get(params, "email")
    password = Map.get(params, "password")

    {email, password}
  end

  defp valid_password?(param_password, user_password), do: param_password == user_password

  defp create_token(user_id) do
    token_data = %{"user_id" => user_id, "exp" => expiration_time()}
    Token.generate_and_sign(token_data)
  end

  defp expiration_time(), do: Joken.current_time() + @time_to_expirate
end
