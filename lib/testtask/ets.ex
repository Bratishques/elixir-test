defmodule Testtask.ETS do

  def prepare_ets(db_name) do
    :ets.new(:db_list, [:set, :public, :named_table])
  end

  def create_table(db_name) do
    :ets.insert(:db_list, {db_name, self()})
    :ets.new(String.to_atom(db_name), [:set, :public, :named_table])
    IO.inspect(:ets.lookup(:db_list, db_name))
  end

  def lookup_table(db_name) do
    case :ets.lookup(:db_list, db_name) do
      [] -> true
    end

  end


end
