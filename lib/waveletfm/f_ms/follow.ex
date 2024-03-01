defmodule WaveletFM.FMs.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "follow" do

    field :from, :binary_id
    field :to, :binary_id
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:id, :from, :to])
    |> validate_required([:id, :from, :to])
    |> unsafe_validate_unique(:id, WaveletFM.Repo)
    |> unique_constraint(:id)
  end
end
