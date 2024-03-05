defmodule Sanito.MixProject do
  use Mix.Project

  def project do
    [
      app: :sanito,
      version: "0.1.0",
      elixir: "~> 1.11",
      description: "Plug health check module",
      package: package(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/erickgnavar/sanito"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      ci: ["format --check-formatted", "test"]
    ]
  end
end
