defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string, null: false
      add :role, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
