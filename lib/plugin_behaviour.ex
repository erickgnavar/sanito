defmodule Sanito.PluginBehaviour do
  @moduledoc """
  Define the features that should be implemented to have a custom plugin
  """

  @doc """
  It will receive all the options sent to `Sanito.Plug`
  """
  @callback check(Plug.Conn.t(), opts :: list) ::
              {:ok, context :: String.t()} | {:error, reason :: String.t()}
end
