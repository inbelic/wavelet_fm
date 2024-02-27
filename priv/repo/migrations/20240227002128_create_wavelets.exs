defmodule WaveletFM.Repo.Migrations.CreateWavelets do
  use Ecto.Migration

  def change do
    create table(:wavelets, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string
      add :artist, :string
      add :links, {:array, :string}
      add :cover, :string
    end

    create unique_index(:wavelets, [:id])
  end
end
