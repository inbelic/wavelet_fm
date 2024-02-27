defmodule WaveletFM.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :wavelet, :string
      add :heat, :integer
      add :love, :integer
      add :wacky, :integer
      add :mood, :integer
      add :fm, references(:fms, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:post, [:fm])
  end
end
