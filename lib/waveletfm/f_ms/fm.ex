defmodule WaveletFM.FMs.FM do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "fms" do
    field :username, :string
    field :freq, :float
    belongs_to :user, WaveletFM.Accounts.User
    has_many :posts, WaveletFM.Posts.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(fm, attrs, opts \\ []) do
    fm
    |> cast(attrs, [:freq, :username])
    |> validate_required([:freq, :username])
    |> validate_freq()
    |> validate_username(opts)
  end

  def validate_freq(changeset) do
    changeset
    |> validate_number(:freq, greater_than_or_equal_to: 88.1, less_than_or_equal_to: 107.9,
      message: "frequency needs to be between 88.1 and 107.9")
    |> validate_decimal()
  end

  defp validate_decimal(changeset) do
    case get_field(changeset, :freq) do
      nil -> changeset
      number -> number
      |> Kernel.*(10)
      |> Kernel.trunc()
      |> Kernel.rem(10)
      |> is_member?([1,3,5,7,9])
      |> case do
        :true -> changeset
        :false -> add_error(changeset, :freq, "decimal value must be 1, 3, 5, 7 or 9")
      end
    end
  end

  defp is_member?(elem, list) do
    Enum.member?(list, elem)
  end

  def validate_username(changeset, opts) do
    changeset
    |> validate_format(:username, ~r/[a-z\.]$/, message: "must only be lowercase letters and .")
    |> maybe_validate_unique_username(opts)
  end

  defp maybe_validate_unique_username(changeset, opts) do
    if Keyword.get(opts, :validate_fm, true) do
      changeset
      |> unsafe_validate_unique(:username, WaveletFM.Repo)
      |> unique_constraint(:username)
    else
      changeset
    end
  end

end
