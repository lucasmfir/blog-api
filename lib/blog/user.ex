defmodule Blog.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email_format ~r/@/

  @required_params [:display_name, :email, :password]
  @optional_params [:image]

  schema "users" do
    field :display_name, :string
    field :email, :string
    field :password, :string
    field :image, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_required(:display_name, min: 8)
    |> validate_required(:password, min: 6)
    |> validate_format(:email, @email_format)
    |> unique_constraint([:email])

  end
end
