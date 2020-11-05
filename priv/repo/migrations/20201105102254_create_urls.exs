defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :initial, :string, null: false
      add :short, :string, null: false

      timestamps()
    end

    create unique_index(:urls, [:short])
  end
end
