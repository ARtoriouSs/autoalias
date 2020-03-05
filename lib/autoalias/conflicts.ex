defmodule Autoalias.Conflicts do
  @moduledoc """
  Provides mechanism for resolving module conflicts
  """

  @doc """
  Accepts list of modules and returns list of modules with resolved conflicts.
  Conflicts solving performs recursively till there will be no conflicts at all.

  If we have several modules with the same ending and alias all of them, only last one will be accepted.
  For example if there is modules like `Foo.Bar.Module` and `Baz.Qux.Corge.Module` it will alias the longest module,
  and closest parent for all conflicted modules. In this case it will be:

  ```elixir
  alias Baz.Qux.Corge.Module
  alias Foo.Bar
  ```

  So we can now use `Module` to access first one and `Bar.Module` for the second.

  Here is the corner case when conflict appears with one-word module, e.g. `Module` and `MyApp.Module`.
  In this case it will create alias for `MyApp.Module` and you will loose direct access to one-word `Module` module.
  If this happened, you can prepend module with `Elixir.` prefix, like `Elixir.Module`, to access it. `Elixir` module
  itself cannot be aliased at all.

  This cases are pretty rare, but it can happen.
  """
  def resolve(modules) do
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

    if has_conflicts?(resolved), do: resolve(resolved), else: resolved
  end

  # Accepts target module and list of modules.
  # Returns map which contains target module and all modules with the same ending, e.g.:
  #
  # %{target: Foo.Bar.Baz, conflicts: [Qux.Baz, Corge.Baz]}
  #
  @doc false
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

  # Checks whether or not modules list has conflicts
  #
  @doc false
  defp has_conflicts?(modules) do
    modules
    |> Enum.any?(fn module ->
      module
      |> get_conflicts(modules)
      |> Map.get(:conflicts)
      |> Enum.any?()
    end)
  end

  # Counts submodules not considering Elixir module, for Foo.Bar it will be 2
  #
  @doc false
  defp submodules_count(Elixir), do: 0
  defp submodules_count(module) do
    module |> Module.split() |> Enum.count()
  end

  # Returns module parent, e.g. for Foo.Bar it will return Foo
  #
  @doc false
  defp last_child(Elixir), do: Elixir
  defp last_child(module) do
    module
    |> Module.split()
    |> List.last()
  end

  # Returns module parent, e.g. for Foo.Bar it will return Foo
  #
  @doc false
  def parent(module) do
    module
    |> Module.split()
    |> Enum.drop(-1)
    |> Module.concat()
  end
end
