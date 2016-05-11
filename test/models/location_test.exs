defmodule PannicServer.LocationTest do
  use PannicServer.ModelCase

  alias PannicServer.Location

  @valid_attrs %{latitude: "some content", longitude: "some content", user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end
