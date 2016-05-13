defmodule PannicServer.Location do
  use PannicServer.Web, :model

  schema "locations" do
    field :user, :string
    field :latitude, :string
    field :longitude, :string
    field :pannic, :string
    timestamps
  end

  @required_fields ~w(latitude longitude pannic user)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
