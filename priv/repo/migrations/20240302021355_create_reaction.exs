defmodule WaveletFM.Repo.Migrations.CreateReaction do
  use Ecto.Migration

  def change do
    create table(:reaction, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :heat, :boolean, default: false, null: false
      add :love, :boolean, default: false, null: false
      add :fm, references(:fms, on_delete: :delete_all, type: :binary_id)
      add :post, references(:posts, on_delete: :delete_all, type: :binary_id)
    end

    create index(:reaction, [:fm])
    create index(:reaction, [:post])
  end
end
