defmodule Blog do
  @moduledoc """
  Blog keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Blog.{Posts, Users}

  defdelegate list_users(), to: Users, as: :list

  defdelegate show_user(user_id), to: Users, as: :show

  defdelegate create_user(params), to: Users, as: :create

  defdelegate delete_user(user_id), to: Users, as: :delete

  defdelegate create_post(params, user_id), to: Posts, as: :create
end
