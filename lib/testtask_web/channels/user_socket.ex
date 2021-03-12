defmodule TesttaskWeb.UserSocket do
  use Phoenix.Socket
  alias Testtask.WebsocketETS
  channel "rooms:*", Testtask.DBChannel
  #ws://localhost:4000/socket/websocket?id=1
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket, _connect_info) do
    IO.inspect(socket)
    {:ok, socket}
  end

  #def handle_in("new_msg", %{"uid" => uid, "body" => body}, socket) do
    #broadcast!(socket, "new_msg", %{uid: uid, body: body})
    #{:noreply, socket}
  #end

  def id(socket), do: nil

end
