# Sanito

Plug health check module, used for example for container healthcheck

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sanito` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sanito, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/sanito>.

## Usage

Define the `plug` module in `endpoint.ex`, this will expose an endpoint for health check, this endpoint won't send
anything to the logger so it is safe to use without worrying about generating tons of logs.

```elixir
defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  ...

  plug Sanito.Plug, path: "/health", plugins: [{Sanito.EctoPlugin, repo: MyApp.Repo}, MyCustomPlugin]
  ...

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  ...

  plug MyAppWeb.Router
end
```

Custom plugins must implement `Sanito.PluginBehaviour`.
