defmodule Frobots.ChangesetError do
  @moduledoc """
  The ChangesetError context.
  """
  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `FrobotsWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def translate_error(%{errors: errors} = _changeset) do
    Enum.map(errors, fn {field, error} ->
      Atom.to_string(field) <> " " <> translate_error(error)
    end)
  end

  def translate_error({msg, opts}) do
    case opts[:count] do
      nil -> Gettext.dgettext(FrobotsWeb.Gettext, "errors", msg, opts)
      count -> Gettext.dngettext(FrobotsWeb.Gettext, "errors", msg, msg, count, opts)
    end
  end
end
