defmodule Testtask.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Testtask.Database
  alias Testtask.WebsocketETS
  alias Testtask.ETS
  alias Testtask.TTL

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TesttaskWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Testtask.PubSub},
      # Start the Endpoint (http/https)
      TesttaskWeb.Endpoint
      # Start a worker by calling: Testtask.Worker.start_link(arg)
      # {Testtask.Worker, arg}
    ]
    TTL.prepare_ttl_manager()
    ETS.prepare_ets()
    ETS.create_table("messages")
    ETS.create_table("phone_numbers")
    ETS.create_table("iq")
    ETS.create_table("iq")
    ETS.delete_table("iq")
    ETS.delete_table("iq")
    ETS.put_value_into_db("messages", "John", "foo")
    ETS.get_value_from_db("messages", "John")
    ETS.get_value_from_db("messages", "Tony")
    ETS.put_value_into_db("messages", "Tony", "bar", "10")
    ETS.get_value_from_db("messages", "Tony")
    ETS.put_value_into_db("messages", "Masha", "Hi", "20")
    ETS.put_value_into_db("messages", "Vitya", "Hello", "20")
    ETS.delete_table("messages")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Testtask.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TesttaskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
