defmodule Autoalias.MixProject do
  use Mix.Project

  def project do
    [
      app: :autoalias,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Alexander Teslovskiy"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ARtoriouSs/autoalias"}
    ]
  end

  defp description do
    """
    TODO
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
