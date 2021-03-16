defmodule TesttaskWeb.UserSocket do
  use Phoenix.Socket
  alias Testtask.WebsocketETS

  channel "db:*", Testtask.DBChannel
  #ws://localhost:4001/socket/websocket?id=1
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, "client#{:os.system_time(:second)}")}
  end


  def id(socket), do: "users_socket:#{socket.assigns.user_id}"

end
