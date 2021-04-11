defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:title, :content, :user_id]

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
