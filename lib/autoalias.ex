defmodule Autoalias do
  @moduledoc """
  TODO: Documentation for Autoalias
  """

  @doc "TODO"
  defmacro __using__(_args) do
    #:code.all_loaded
    [{Foo.Bar.Keks, 'asd'}, {Lel.Keks, ''}]
    |> Enum.map(fn {module, _path} -> module end)
    |> Enum.filter(&elixir_module?/1)
    |> resolve_conflicts
    |> Enum.map(&quote_alias/1)
    |> quote_block
  end

  defp elixir_module?(module) do
    match?("Elixir." <> _, Atom.to_string(module))
  end

  defp resolve_conflicts(modules) do
    keks =
      modules
      |> Enum.map(fn module -> get_conflicts(module, modules) end)

          require IEx; IEx.pry


  end

  defp get_conflicts(target, modules) do
    conflicts =
      modules
      |> Enum.reduce({}, fn module, conflicts ->
        if module != target and last_child(module) == last_child(target) do
          Tuple.append(conflicts, module)
        else
          conflicts
        end
      end)

    [target: target, conflicts: conflicts]
  end

  defp last_child(module) do
    module
    |> Atom.to_string
    |> String.split(".")
    |> Enum.take(-1)
  end

  defp quote_alias(module) do
    {
      :alias,
      [context: Autoalias],
      [{:__aliases__, [alias: false], module}]
    }
  end

  defp quote_block(aliases), do: {:__block__, [], aliases}
end
