defmodule Testtask.ETS do

  alias Testtask.TTL
  alias Testtask.Wrapper

  def prepare_ets() do
    :ets.new(:db_list, [:set, :public, :named_table])
  end



  def create_table(db_name) do
    case lookup_table(db_name) do
      {:exists, _result} ->
        IO.inspect("Databse #{db_name} already exists")
        {:error, db_name}
      {:no_table, _message} ->
        kernel = :application.info[:running][:kernel]
        data = :ets.new(:table, [:public, :set])
        :ets.give_away(data, kernel, {})
        :ets.insert(:db_list, {db_name, data})
        {:ok, db_name}
    end
  end

  def delete_table(db_name) do
    case lookup_table(db_name) do
      {:exists, {db_name, ref}} ->
        IO.inspect(ref)
        :ets.delete(ref)
        :ets.delete(:db_list, db_name)
        TTL.erase_ttl_data(db_name)
        IO.inspect("Deleted #{db_name} database")
        {:ok, db_name}
      {:no_table, _result} ->
        IO.inspect("Nothing to delete")
        {:error, db_name}
    end
  end

  def put_value_into_db(db_name, key, value) do
    case lookup_table(db_name) do
      {:exists, {db_name, ref}} ->
        :ets.insert(ref, {key, value})
        IO.inspect("Inserted #{key}:#{value} into #{db_name}")
        {:ok, db_name}
      {:no_table, _result} ->
        IO.inspect("No such database")
        {:error, false}
    end
  end

  def put_value_into_db(db_name, key, value, ttl) do
    case lookup_table(db_name) do
      {:exists, {db_name, ref}} ->
        :ets.insert(ref, {key, value})
        TTL.new_ttl_data(db_name, key, :os.system_time(:second) + String.to_integer(ttl))
        IO.inspect("Inserted #{key}:#{value} into #{db_name} with ttl of #{ttl} seconds")
        {:ok, {db_name, key}}
      {:no_table, _result} ->
        IO.inspect("No such database")
        {:error, false}
    end
  end

  def erase_value_from_db(db_name, key) do
    case lookup_table(db_name) do
      {:exists, {db_name, ref}} ->
        case :ets.delete(ref, key) do
          true ->
            TTL.erase_ttl_data(db_name, key)
            IO.inspect("Deleted #{key} from #{db_name}")
            {:ok, {db_name, key}}
          false ->
            IO.inspect("No such key in database #{db_name}")
            {:error, {db_name, key}}
        end
      {:no_table, _result} ->
        IO.inspect("No such database")
        {:error, db_name}
    end
  end


  def get_value_from_db(db_name, key) do
    case lookup_table(db_name) do
      {:exists, {db_name, ref}} ->
        case :ets.lookup(ref, key) do
          [{key, value}] ->
            IO.inspect("Found #{key}:#{value} in database #{db_name}")
            {:ok, {key, value}}
          [] ->
            IO.inspect("No #{key} key found in database #{db_name}")
            {:no_key, {db_name, key}}
          end
      {:no_table, _result} ->
        IO.inspect("No such database")
        {:no_db, db_name}
      end
  end



  def lookup_table(db_name) do
    case :ets.lookup(:db_list, db_name) do
      [database] -> {:exists, database}
      [] -> {:no_table, "No such table"}
    end
  end


end
