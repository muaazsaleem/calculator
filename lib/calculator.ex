defmodule Calculator do
  use Application
  require Logger

  def start(_type, _args) do

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Calculator.Server, [], [port: 8080])
    ]

    opts = [strategy: :one_for_one, name: Calculator.Supervisor]

    Logger.info("Application Started")

    Supervisor.start_link(children, opts)
  end
end


defmodule Calculator.Server do
  use Plug.Builder

  plug Plug.Static,
    at: "/",
    from: :calculator

  plug :not_found

  def not_found(conn, _opts) do
    send_resp(conn, 404, "not found")
  end
end