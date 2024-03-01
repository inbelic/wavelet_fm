defmodule WaveletFM.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :heat, :integer
      add :love, :integer
      add :wacky, :integer
      add :mood, :integer
      add :wavelet_id, references(:wavelets, on_delete: :delete_all, type: :string)
      add :fm_id, references(:fms, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:fm_id])
    create index(:posts, [:wavelet_id])
  end
end
