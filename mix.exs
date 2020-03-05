defmodule Autoalias.MixProject do
  use Mix.Project

  def project do
    [
      app: :autoalias,
      version: "0.2.0",
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
    "Alias all your modules in iex shell with a single command!"
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
