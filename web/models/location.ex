defmodule PannicServer.Location do
  use PannicServer.Web, :model

  schema "locations" do
    field :user, :string
    field :latitude, :string
    field :longitude, :string
    timestamps
  end

  @required_fields ~w(latitude longitude)
  @optional_fields ~w(user)

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
