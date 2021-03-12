defmodule Testtask.TTL do

  alias Testtask.Database
  alias Testtask.ETS


  def prepare_ttl_manager() do
    :ets.new(:ttl_manager, [:public, :named_table, :set])
    :timer.apply_interval(1000, Testtask.TTL, :check_ttl_table, [])
  end

  def erase_ttl_data(db_name) do
    :ets.foldl(fn {{database, key}, expiration_time}, _acc ->
      if db_name == database do
        IO.inspect("Deleted ttl entry of #{db_name}")
        :ets.delete(:ttl_manager, {db_name, key})
      else
      end
    end,
    [],
    :ttl_manager)
  end

  def erase_ttl_data(db_name, key) do
    IO.inspect("Deleted ttl entry of #{db_name} #{key}")
    :ets.delete(:ttl_manager, {db_name, key})
  end

  def new_ttl_data(db_name, key, expiration_time) do
    :ets.insert(:ttl_manager, {{db_name, key}, expiration_time})
  end

  def check_ttl_table do
    :ets.foldl(fn {{db_name, key}, expiration_time}, _acc ->
        if expiration_time > :os.system_time(:second) do
        else
          ETS.erase_value_from_db(db_name, key)
        end
      end,
      [],
      :ttl_manager)
  end
end
