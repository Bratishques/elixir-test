defmodule TesttaskWeb.DBController do
  use TesttaskWeb, :controller

  alias Testtask.Database
  alias Testtask.TTL

  @db :database

  def delete_keys(conn, %{"database" => db_name}) do
    body = conn.body_params["_json"]
    Enum.map(body,
    fn key ->
      Database.delete_from_db(db_name, key)
    end)
    json(conn, "Deleted values")
  end

  def insert_values(conn, %{"database" => db_name}) do
    IO.inspect(conn)
    body = conn.body_params["_json"]
    data = Enum.map(body,
    fn kv ->
      cond do
        is_map(kv) ->
        if Map.has_key?(kv, "key") and Map.has_key?(kv, "key") do
          Database.insert_in_db(db_name, kv["key"], kv["value"])
          if Map.has_key?(kv, "ttl") do
            TTL.new_ttl_data(db_name, kv["key"], (:os.system_time(:second) + String.to_integer(kv["ttl"])))
          end
        end
          %{kv["key"] => true}
          true -> false
      end

    end)
    json(conn, data)
  end

  def get_database(conn, %{"database" => db_name}) do
    if (Map.has_key?(conn.query_params, "key")) do
      data = Database.lookup_db_value(db_name, conn.query_params["key"])
      json(conn, data)
    else
      data = Database.lookup_db(db_name)
      json(conn, data)
    end
  end

  def all(conn, _params) do
    tables = Database.lookup_dbs()
    json(conn, tables)
  end


end
