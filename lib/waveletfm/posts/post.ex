defmodule WaveletFM.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :heat, :integer
    field :love, :integer
    field :wacky, :integer
    field :mood, :integer
    belongs_to :fm, WaveletFM.FMs.FM
    belongs_to :wavelet, WaveletFM.Wavelets.Wavelet, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:fm_id, :wavelet_id, :heat, :love, :wacky, :mood])
    |> validate_required([:fm_id, :wavelet_id, :heat, :love, :wacky, :mood])
  end
end
