defmodule WaveletFM.Accounts.UserFM do
  alias WaveletFM.Accounts.{User, UserFM}
  alias WaveletFM.FMs.FM
  
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    
    field :username, :string
    field :freq, :float
  end
  
  @doc """
  A user_fm changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user_or_user_fm, attrs, opts \\ [])
  def registration_changeset(%User{} = user, attrs, opts) do
    user
    |> cast(attrs, [:email, :password])
    |> User.validate_email(opts)
    |> validate_password(opts)
  end

  def registration_changeset(%UserFM{} = user_fm, attrs, opts) do
    user_fm
    |> cast(attrs, [:freq, :username, :email, :password])
    |> validate_required([:freq, :username])
    |> FM.validate_freq()
    |> FM.validate_username([{:validate_fm, false} | opts])
    |> User.validate_email(opts)
    |> validate_password(opts)
  end

  def validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
