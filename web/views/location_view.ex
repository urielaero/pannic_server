defmodule PannicServer.LocationView do
  use PannicServer.Web, :view

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, PannicServer.LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, PannicServer.LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      user: location.user,
      latitude: location.latitude,
      longitude: location.longitude,
      pannic: location.pannic}
  end
end
