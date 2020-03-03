defmodule Autoalias do
  @moduledoc """
  Documentation for Autoalias.
  """

  defmacro __using__(_args) do
    :code.all_loaded
    |> Enum.map(fn {module, _path} -> module end)
    |> Enum.filter(&elixir_module?/1)
    |> Enum.map(&quote_alias/1)
    |> quote_block
  end

  defp quote_alias(module) do
    {
      :alias,
      [context: Autoalias],
      [{:__aliases__, [alias: false], module}]
    }
  end

  defp quote_block(aliases), do: {:__block__, [], aliases}

  defp elixir_module?(module) do
    match?("Elixir." <> _, Atom.to_string(module))
  end
end
