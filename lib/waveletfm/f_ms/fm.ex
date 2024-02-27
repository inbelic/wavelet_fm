defmodule WaveletFM.FMs.FM do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "fms" do
    field :username, :string
    field :freq, :float
    belongs_to :user, WaveletFM.Accounts.User
    has_many :post, WaveletFM.Posts.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(fm, attrs) do
    fm
    |> cast(attrs, [:freq, :username])
    |> validate_required([:freq, :username])
  end
end
