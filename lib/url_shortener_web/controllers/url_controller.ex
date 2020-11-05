defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller
  require Logger
  alias UrlShortener.Url
  alias UrlShortener.Repo

  def index(conn, _params) do
    conn
    |> assign(:urls, Repo.all(UrlShortener.Url))
    |> assign(:base_url, base_url(conn))
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Url.changeset(%Url{})

    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:url, base_url(conn) <> Repo.get(Url, id).short)
    |> render("show.html")
  end

  def create(conn, %{"url" => params}) do
    url_params = Map.put(params, "short", short_url())

    %Url{}
    |> Url.changeset(url_params)
    |> Repo.insert()
    |> case do
      {:ok, url} ->
        conn
        |> put_flash(:info, "Url shortened successfully.")
        |> redirect(to: Routes.url_path(conn, :show, url.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def handle_redirect(conn, _params) do
    path = List.first(conn.path_info)

    url = UrlShortener.Url
          |> Repo.get_by(short: path)

    redirect(conn, external: url.initial)
  end

  defp base_url(conn) do
    Routes.url_url(conn, :new)
  end

  defp short_url do
    :crypto.strong_rand_bytes(10) |> Base.url_encode64 |> binary_part(0, 10)
  end
end
