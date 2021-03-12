defmodule Chat.RoomChannel do
  def join("rooms:lobby", message, socket) do
    :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})
    {:ok, socket}
  end
end
