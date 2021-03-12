defmodule Testtask.Wrapper do
  use GenServer

  def init(arg) do
    :ets.new(:wrapper, [
      :set,
      :public,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])
    {:ok, arg}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def new_table(db_name) do
    :ets.new(db_name, [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])
  end

  def get(key) do
    case :ets.lookup(:wrapper, key) do
      [] ->
        nil
      [{_key, value}] ->
        value
    end
  end

  def put(key, value) do
    :ets.insert(:wrapper, {key, value})
  end
end
