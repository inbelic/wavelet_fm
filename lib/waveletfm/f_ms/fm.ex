defmodule WaveletFM.FMs.FM do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "fms" do
    field :username, :string
    field :freq, :float
    field :wavelets, {:array, :string}
    belongs_to :user, WaveletFM.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(fm, attrs) do
    fm
    |> cast(attrs, [:freq, :username, :wavelets])
    |> validate_required([:freq, :username, :wavelets])
  end
end
