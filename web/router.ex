defmodule PannicServer.Router do
  use PannicServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PannicServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", PannicServer do
    pipe_through :api
    
    resources "/locations", LocationController, except: [:new, :edit]
  end
end
