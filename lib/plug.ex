defmodule Sanito.Plug do
  @moduledoc """
  Plug to expose an endpoint for healthcheck

  It can be configured to run any plugin that implements `Sanito.PluginBehaviour`
  it will return a text response with the details of all the plugins results
  """
  @behaviour Plug

  import Plug.Conn
  alias Plug.Conn

  @impl true
  def init(opts) do
    %{
      health_path: Keyword.get(opts, :path, "/health"),
      plugins: Keyword.get(opts, :plugins, [])
    }
  end

  @impl true
  def call(%Conn{request_path: health_path} = conn, %{health_path: health_path, plugins: plugins}) do
    executions =
      Enum.map(plugins, fn
        {plugin_module, opts} when is_atom(plugin_module) and is_list(opts) ->
          try_apply(plugin_module, [conn, opts])

        plugin_module when is_atom(plugin_module) ->
          try_apply(plugin_module, [conn, []])
      end)

    body =
      case parse_messages(executions) do
        "" -> "OK"
        body -> body
      end

    errors? =
      executions
      |> Enum.filter(fn {result, _} -> result == :error end)
      |> Enum.count()
      |> Kernel.>(0)

    status = if errors?, do: 503, else: 200

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(status, body)
    |> halt()
  end

  def call(conn, _opts) do
    conn
  end

  @spec parse_messages([{:ok, String.t()} | {:error, String.t()}]) :: String.t()
  defp parse_messages(messages) do
    messages
    |> Enum.map(fn
      {:ok, message} ->
        "OK #{message}"

      {:error, message} ->
        "ERROR #{message}"
    end)
    |> Enum.join("\n")
  end

  defp try_apply(module, opts) do
    try do
      apply(module, :check, opts)
    rescue
      e -> {:error, Exception.message(e)}
    end
  end
end
