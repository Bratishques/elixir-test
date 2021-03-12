defmodule TesttaskWeb.DBController do
  use TesttaskWeb, :controller

  @doc """
  Previous iteration of DBController
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
"""

  alias Testtask.ETS

  def create(conn, %{"database" => db_name}) do
    case ETS.create_table(db_name) do
      {:ok, db_name} ->
        conn
        |> put_status(:created)
        |> json(%{db_name => true})
      {:error, db_name} ->
        IO.inspect(db_name)
        conn
        |> put_status(:already_exists)
        |> json(%{db_name => false})
    end
  end

  def delete(conn, %{"database" => db_name}) do
    case ETS.delete_table(db_name) do
      {:ok, db_name} ->
        conn
        |> put_status(200)
        |> json(%{db_name => true})
      {:error, db_name} ->
        conn
        |> put_status(404)
        |> json(%{db_name => false})
    end
  end

  def get(conn, %{"database" => db_name, "key" => key}) do
    case ETS.get_value_from_db(db_name, key) do
      {:ok, {key, value}} ->
        conn
        |> put_status(200)
        |> json(%{key => value})
      {:no_key, {_db_name, key}} ->
        conn
        |> put_status(404)
        |> json(%{key => "not found"})
      {:no_db, db_name} ->
        conn
        |> put_status(404)
        |> json(%{db_name => "not found"})
    end
  end

  def put(db_name, batch) do

  end

  def erase(db_name, key) do

  end
end
