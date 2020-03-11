defmodule Alpa.MixProject do
  use Mix.Project

  def project do
    [
      app: :alpa,
      version: "0.1.4",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "api wrapper for alpaca.markets",
      source_url: "https://github.com/phiat/alpa",
      name: "alpa"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Alpa.Application, []}
    ]
  end

  # package build
  def package do
    [
      maintainers: [" phiat "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/phiat/alpa"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
