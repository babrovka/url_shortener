defmodule UrlShortener.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :initial, :string, null: false
    field :short, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(url, attrs \\ %{}) do
    url
    |> cast(attrs, [:initial, :short])
    |> unique_constraint(:short)
    |> validate_required([:initial, :short])
  end
end
