defmodule WaveletFM.Wavelets.Wavelet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "wavelets" do
    field :links, {:array, :string}
    field :title, :string
    field :cover, :string
    field :artist, :string
  end

  @doc false
  def changeset(wavelet, attrs) do
    wavelet
    |> cast(attrs, [:id, :title, :artist, :links, :cover])
    |> validate_required([:id, :title, :artist])
    |> unsafe_validate_unique(:id, WaveletFM.Repo)
    |> unique_constraint(:id)
  end
end
