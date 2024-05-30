defmodule Sanito.Plugins.EctoPlugin do
  @moduledoc """
  Simple connection check to a given Ecto repo

  It only tries to execute a simple query to verify the connection
  is done successfully

  It can be used as the following example:
  ```
  plug Sanito.Plug, plugins: [{Sanito.EctoPlugin, repo: MyApp.Repo}]
  ```
  """
  @behaviour Sanito.PluginBehaviour

  @impl true
  def check(_conn, opts) do
    repo = Keyword.fetch!(opts, :repo)

    case Ecto.Adapters.SQL.query(repo, "select ", []) do
      {:ok, _} -> {:ok, "Database connection is fine"}
      {:error, %{message: message}} -> {:error, "Ecto error: #{message}"}
    end
  end
end
