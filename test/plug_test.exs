defmodule PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "return 200 with default path" do
    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init([]))
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "return 200 with custom path" do
    conn = conn(:get, "/custom-health")
    conn = Sanito.Plug.call(conn, %{health_path: "/custom-health"})
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end
end
