defmodule Autoalias do
  @moduledoc """
  TODO: Documentation for Autoalias
  """

  @doc "TODO"
  defmacro __using__(_args) do
    :code.all_loaded()
    # [{Lel.Keks, ''}, {Foo.Bar.Keks, ''}, {Pop.Aaa, ''}]
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
    resolved =
      modules
      |> Enum.sort(fn first, second -> submodules_count(first) <= submodules_count(second) end)
      |> Enum.map(fn module -> get_conflicts(module, modules) end)
      |> Enum.dedup_by(fn %{target: target} -> last_child(target) end)
      |> Enum.map(fn %{conflicts: conflicts} -> conflicts end)
      |> List.flatten()
      |> Enum.reduce(modules, fn module, modules ->
        modules
        |> List.delete(module)
        |> List.insert_at(-1, parent(module))
      end)

    if has_conflicts?(resolved), do: resolve_conflicts(resolved), else: resolved
  end

  defp submodules_count(Elixir), do: 0

  defp submodules_count(module) do
    module |> Module.split() |> Enum.count()
  end

  defp get_conflicts(target, modules) do
    conflicts =
      modules
      |> Enum.reduce([], fn module, conflicts ->
        if module != target and last_child(module) == last_child(target) do
          conflicts ++ [module]
        else
          conflicts
        end
      end)

    %{target: target, conflicts: conflicts}
  end

  defp has_conflicts?(modules) do
    modules
    |> Enum.any?(fn module ->
      module
      |> get_conflicts(modules)
      |> Map.get(:conflicts)
      |> Enum.any?()
    end)
  end

  defp last_child(Elixir), do: Elixir

  defp last_child(module) do
    module
    |> Module.split()
    |> List.last()
  end

  def parent(module) do
    module
    |> Module.split()
    |> Enum.drop(-1)
    |> Module.concat()
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
