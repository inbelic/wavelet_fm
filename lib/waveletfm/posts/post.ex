defmodule WaveletFM.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "post" do
    field :wavelet, :string
    field :heat, :integer
    field :love, :integer
    field :wacky, :integer
    field :mood, :integer
    belongs_to :fm, WaveletFM.FMs.Fm

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:wavelet, :heat, :love, :wacky, :mood])
    |> validate_required([:wavelet, :heat, :love, :wacky, :mood])
  end
end
