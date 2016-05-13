defmodule PannicServer.LocationControllerTest do
  use PannicServer.ConnCase

  alias PannicServer.Location
  @valid_attrs %{latitude: "some content", longitude: "some content", user: "some@content.com", pannic: "uuid-1"}
  @invalid_attrs %{}

  @mailer_api Util.Mailer.InMemory

  setup do
    @mailer_api.start_link
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, location_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = get conn, location_path(conn, :show, location)
    assert json_response(conn, 200)["data"] == %{"id" => location.id,
      "user" => location.user,
      "latitude" => location.latitude,
      "longitude" => location.longitude,
      "pannic" => location.pannic}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, location_path(conn, :show, "54da3fde31f40c76004324c9")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, location_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, location_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = put conn, location_path(conn, :update, location), location: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = put conn, location_path(conn, :update, location), location: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = delete conn, location_path(conn, :delete, location)
    assert response(conn, 204)
    refute Repo.get(Location, location.id)
  end

  test "notify only once time by pannic field", %{conn: conn} do
    attrs = @valid_attrs |> Dict.put(:pannic, "pa-1")
    conn = post conn, location_path(conn, :create), attrs 
    assert json_response(conn, 201)["data"]["id"]
    assert @mailer_api.get_inbox(attrs.user)
    conn = post conn, location_path(conn, :create), attrs
    assert json_response(conn, 201)["data"]["id"]
    refute @mailer_api.get_inbox(attrs.user)
    attrs = attrs |> Dict.put(:pannic, "pa-2")
    conn = post conn, location_path(conn, :create), attrs
    assert json_response(conn, 201)["data"]["id"]
    assert @mailer_api.get_inbox(attrs.user)
  end
end
