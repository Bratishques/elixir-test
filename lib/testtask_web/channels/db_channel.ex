defmodule Testtask.DBChannel do
  use Phoenix.Channel
  alias Testtask.WebsocketETS

  def join("db:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, "You are a homo"}, socket }
  end

  def handle_in("subscribe", payload, socket) do
    IO.inspect(payload)
    {:reply, {:ok, "You are a homo"}, socket}
  end

  def leave(socket) do
    IO.inspect("user left #{socket.assigns.user_id}")
    WebsocketETS.remove_client(socket.assigns.user_id)
    {:ok, socket}
  end


end
