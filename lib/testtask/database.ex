defmodule Testtask.Database do
  alias Testtask.TTL

  def prepare_database do
    :ets.new(:database,[:named_table, :set, :public])
    :ets.insert(:database, {{"messages", "John"}, "bar"})
    :ets.insert(:database, {{"messages", "Tony"}, "foo"})
    :ets.insert(:database, {{"phone_numbers", "John"}, "88005553535"})
    :ets.insert(:database, {{"phone_numbers", "Tony"}, "88002281337"})
    :ets.insert(:database, {{"iq", "John"}, "60"})
    :ets.insert(:database, {{"iq", "Tony"}, "69"})
    TTL.prepare_ttl_manager()
    TTL.new_ttl_data("messages", "John", :os.system_time(:second) + 10)
  end

  def insert_in_db(db_name, key, value) do
    :ets.insert(:database, {{db_name, key}, value})
  end


  def delete_from_db(db_name, key) do
    :ets.delete(:database, {db_name, key})
    :ets.delete(:ttl_manager, {db_name, key})
  end

  def check_if_db(db_name) do
    if is_map(lookup_db(db_name)) == nil do
      false
    else
      true
    end
  end

  def lookup_db_value(db_name, key) do
    db_data = lookup_db(db_name)
    %{db_name => %{key => db_data[db_name][key]}}
  end

  def lookup_db(db_name) do
   data = Enum.filter(lookup_dbs(), fn x ->
        Map.has_key?(x, db_name)
      end)
    case data do
      [] -> nil
      _ -> [head] = data
      head
    end
  end

  def lookup_dbs() do
    :ets.foldl(
      fn {{database, key}, value}, acc ->
          if Enum.any?(acc,
            fn x ->
              Map.has_key?(x, database)
            end)
        do
          Enum.map(acc,
          fn x ->
            if Map.has_key?(x, database) do
             %{database => Map.merge(x[database], %{key =>value})}
            else
              x
            end
          end)
        else
          acc ++ [%{database => %{key =>value}}]
        end
      end,
      [],
      :database
    )
  end
end
