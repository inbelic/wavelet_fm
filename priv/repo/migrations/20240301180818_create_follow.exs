defmodule WaveletFM.Repo.Migrations.CreateFollow do
  use Ecto.Migration

  def change do
    create table(:follow, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :from, references(:fms, on_delete: :nothing, type: :binary_id)
      add :to, references(:fms, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:follow, [:from])
    create index(:follow, [:to])
  end
end
