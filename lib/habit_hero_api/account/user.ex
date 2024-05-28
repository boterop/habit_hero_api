defmodule HabitHeroApi.Account.User do
  @moduledoc """
  Module for defining the schema for the 'users' table.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{email: String.t(), password: String.t()}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_email()
    |> password_to_hash()
  end

  defp password_to_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp password_to_hash(changeset), do: changeset

  defp validate_email(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset) do
    email_regex = ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

    if !String.match?(email, email_regex) do
      add_error(changeset, :email, "is not a valid email")
    else
      changeset
    end
  end

  defp validate_email(changeset), do: changeset
end
