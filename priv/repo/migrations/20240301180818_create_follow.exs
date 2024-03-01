defmodule WaveletFM.Repo.Migrations.CreateFollow do
  use Ecto.Migration

  def change do
    create table(:follow, primary_key: false) do
      add :id, :string, primary_key: true
      add :from, references(:fms, on_delete: :delete_all, type: :binary_id)
      add :to, references(:fms, on_delete: :delete_all, type: :binary_id)
    end

    create index(:follow, [:from])
    create index(:follow, [:to])
  end
end
