defmodule Testtask.WebsocketETS do
  def prepare_storage() do
    :ets.new(:socket_clients, [:bag, :named_table, :public])
  end

  def insert_client(id) do
    if length(find_client(id)) == 0 do
      :ets.insert(:socket_clients, {id,[]})
    end
  end

  def find_client(id) do
    :ets.lookup(:socket_clients, id)
  end

  def subscribe_client(dbname, key) do

  end

end
