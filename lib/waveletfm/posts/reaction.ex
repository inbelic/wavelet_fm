defmodule WaveletFM.Posts.Reaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reaction" do
    field :heat, :boolean, default: false
    field :love, :boolean, default: false
    belongs_to :fm, :binary_id
    belongs_to :post, :binary_id
  end

  @doc false
  def changeset(reaction, attrs) do
    reaction
    |> cast(attrs, [:heat, :love])
    |> validate_required([:heat, :love])
  end
end
