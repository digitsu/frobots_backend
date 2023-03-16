defmodule Frobots.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Frobots.Accounts` context.
  """

  # Generate a user.
  defp dummy_user() do
    %{
      email: "some@username.com",
      name: unique_user_name(),
      # username: "some@username.com", // old field for email (primary key)
      password: dummy_password(),
      admin: false,
      active: true,
      migrated_user: false,
      hashed_password_old: "$pbkdf2-sha512$160000$abc123$abcd123def"
    }

    # note: hashed_password_old must be in the following pattern -  $pbkdf2-sha512$99999$abcd12ef
    # otherwise Pbkdf2.verify_pass(password, hashed_password_old) fails with pattern match error
  end

  def user_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, dummy_user())
    # attrs = Map.put_new(attrs, :email, attrs.email)
    # attrs = Map.put_new(attrs, :name, unique_user_name())

    # returns {:ok, user}
    case Frobots.Accounts.get_user_by_email(attrs.email) do
      %Frobots.Accounts.User{} = user ->
        Frobots.Accounts.update_registration(user, attrs)

      nil ->
        Frobots.Accounts.register_user(attrs)
    end

    # return a copy with the password nilified, Why?
    # Map.put(user, :password, nil)
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "helloworld!"

  def unique_user_name, do: "user#{System.unique_integer()}"

  def dummy_password, do: "supersecret"

  @spec valid_user_attributes(any) :: any
  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
