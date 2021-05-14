defmodule Crystal.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text
      add :likes_count, :integer
      add :reposts_count, :integer
      #add :user_id, references(:users, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: true

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
