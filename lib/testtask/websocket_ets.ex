defmodule Testtask.WebsocketETS do
  def prepare_storage() do
    :ets.new(:socket_clients, [:bag, :named_table, :public])
  end

  def remove_client(id) do
    :ets.delete(:socket_client, id)
  end

  def find_client(id) do
    :ets.lookup(:socket_clients, id)
  end

  def subscribe_client(id, db_name, key) do
    IO.inspect("inserted client #{id}")
    :ets.insert(:socket_clients, {{db_name, key}, id})
  end

end
