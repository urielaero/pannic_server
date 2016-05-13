defmodule PannicServer.LocationController do
  use PannicServer.Web, :controller

  alias PannicServer.Location

  @mailer_api Application.get_env(:pannic_server, :mailer_api) 

  def index(conn, _params) do
    locations = Repo.all(Location)
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"_json" => params}) do
    IO.puts params
    create(conn, params)
  end

  def create(conn, location_params) do
    changeset = Location.changeset(%Location{}, location_params)

    case Repo.insert(changeset) do
      {:ok, location} ->
        notify(location)
        conn
        |> put_status(:created)
        |> put_resp_header("location", location_path(conn, :show, location))
        |> render("show.json", location: location)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PannicServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Repo.get!(Location, id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Repo.get!(Location, id)
    changeset = Location.changeset(location, location_params)

    case Repo.update(changeset) do
      {:ok, location} ->
        render(conn, "show.json", location: location)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PannicServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Repo.get!(Location, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(location)

    send_resp(conn, :no_content, "")
  end

  defp notify(location) do
    if @mailer_api.in_memory? do 
      do_notify(location)
    else
      spawn_link fn -> 
        do_notify(location)
      end
    end
  end

  defp do_notify(location) do
    if Location.only_one_pannic?(location) do
      url = "Se activo el boton de panico, por favor ingresa  <a href='reepsy.com/?user=#{location.user}&pannic=#{location.pannic}'>aquí</a>"
    
      @mailer_api.send_notify(location.user, "ALERTA", url)
    end
  end
end
