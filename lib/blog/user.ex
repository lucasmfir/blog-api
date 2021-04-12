defmodule Blog.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  alias Blog.Post

  @email_format ~r/@/

  @required_params [:display_name, :email, :password]
  @optional_params [:image]

  schema "users" do
    field :display_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :image, :string
    has_many :posts, Post

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_length(:display_name, min: 8)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, @email_format)
    |> unique_constraint([:email], message: "Usuário já existe")
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
