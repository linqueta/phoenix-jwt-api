defmodule MyApiWeb.Router do
  use MyApiWeb, :router

  alias MyApi.Guardian

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

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", MyApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api/v1", MyApiWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", MyApiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyApiWeb do
  #   pipe_through :api
  # end
end
