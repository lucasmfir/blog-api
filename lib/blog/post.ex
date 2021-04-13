defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.User

  @required_params ~w(title content user_id)a

  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
