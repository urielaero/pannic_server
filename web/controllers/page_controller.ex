defmodule PannicServer.PageController do
  use PannicServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
