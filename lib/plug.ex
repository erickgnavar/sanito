defmodule Sanito.Plug do
  @moduledoc """
  Plug to expose an endpoint for healthcheck
  """
  @behaviour Plug

  import Plug.Conn
  alias Plug.Conn

  @impl true
  def init(opts) do
    %{health_path: Keyword.get(opts, :path, "/health")}
  end

  @impl true
  def call(%Conn{request_path: health_path} = conn, %{health_path: health_path}) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
    |> halt()
  end

  def call(conn, _opts) do
    conn
  end
end
