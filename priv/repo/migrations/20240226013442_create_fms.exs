defmodule WaveletFM.Repo.Migrations.CreateFms do
  use Ecto.Migration

  def change do
    create table(:fms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :freq, :float
      add :username, :string
      add :wavelets, {:array, :string}
      add :user, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:fms, [:user])
  end
end