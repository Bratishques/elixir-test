defmodule Testtask.TTL do

  alias Testtask.Database

  def prepare_ttl_manager() do
    :ets.new(:ttl_manager, [:public, :named_table, :set])
    :timer.apply_interval(1000, Testtask.TTL, :check_ttl_table, [])
  end

  def new_ttl_data(db_name, key, expiration_time) do
    :ets.insert(:ttl_manager, {{db_name, key}, expiration_time})
  end

  def check_ttl_table do
    :ets.foldl(fn x, _acc ->
      {{db_name, key}, expiration_time} = x
        if expiration_time > :os.system_time(:second) do
        else
          Database.delete_from_db(db_name, key)
        end
      end,
      [],
      :ttl_manager)
  end
end
