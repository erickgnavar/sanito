defmodule PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "return 200 with default path" do
    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init([]))
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end

  test "return 200 with custom path" do
    conn = conn(:get, "/custom-health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init(path: "/custom-health"))
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end

  test "return 200 with custom plugin that checks ok" do
    defmodule CustomPluginOK do
      @behaviour Sanito.PluginBehaviour

      def check(_conn, _opts) do
        {:ok, "custom plugin"}
      end
    end

    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init(plugins: [CustomPluginOK]))
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK custom plugin"
  end

  test "return 503 with custom plugin that checks error" do
    defmodule CustomPluginError do
      @behaviour Sanito.PluginBehaviour

      def check(_conn, _opts) do
        {:error, "there was an error with service"}
      end
    end

    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init(plugins: [CustomPluginError]))
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == "ERROR there was an error with service"
  end

  test "return 503 with custom plugin that raises an exception" do
    defmodule CustomPluginException do
      @behaviour Sanito.PluginBehaviour

      def check(_conn, _opts) do
        raise "oops"
      end
    end

    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init(plugins: [CustomPluginException]))
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == "ERROR oops"
  end

  test "return 503 with 2 checks" do
    defmodule CustomPlugin1 do
      @behaviour Sanito.PluginBehaviour

      def check(_conn, _opts) do
        {:ok, "service good"}
      end
    end

    defmodule CustomPlugin2 do
      @behaviour Sanito.PluginBehaviour

      def check(_conn, _opts) do
        raise "something wrong"
      end
    end

    conn = conn(:get, "/health")
    conn = Sanito.Plug.call(conn, Sanito.Plug.init(plugins: [CustomPlugin1, CustomPlugin2]))
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == "OK service good\nERROR something wrong"
  end
end
