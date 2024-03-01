defmodule WaveletFM.Wavelets.Wavelet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  @derive {Jason.Encoder, except: [:__meta__, :__struct__, :posts]}
  schema "wavelets" do
    field :links, {:array, :string}
    field :title, :string
    field :cover, :string
    field :artist, :string
    has_many :posts, WaveletFM.Posts.Post
  end

  @doc false
  def changeset(wavelet, attrs) do
    wavelet
    |> cast(attrs, [:id, :title, :artist, :links, :cover])
    |> validate_required([:id, :title, :artist])
    |> unsafe_validate_unique(:id, WaveletFM.Repo)
    |> unique_constraint(:id)
  end

  @doc false
  def search_changeset(wavelet, attrs) do
    wavelet
    |> cast(attrs, [:title, :artist])
  end
end
