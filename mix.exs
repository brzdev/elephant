defmodule Elephant.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elephant,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :postgrex, :ecto, :httpotion, :twilex],
      mod: {Elephant.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.11"},
      {:httpotion, "~> 3.0.0"},
      {:poison, "~> 2.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:twilex, "~> 0.0.1"}
      # {:ex_twilio, "~> 0.4.0"}
      # {:nexmo, "~> 0.1.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
