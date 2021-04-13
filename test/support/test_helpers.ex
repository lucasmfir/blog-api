defmodule Blog.TestHelpers do
  def changeset_error_msg(changeset, required_key) do
    {_reason, {error_msg, _}} =
      Enum.find(changeset.errors, fn {key, msg} -> key == required_key end)

    error_msg
  end
end
