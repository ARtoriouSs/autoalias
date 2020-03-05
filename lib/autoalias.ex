defmodule Autoalias do
  @moduledoc """
  Provides macro for aliasing modules in iex shell.

  Simply do the following and it will (try) to load aliases for
  all accessible modules:

  ```elixir
  use Autoalias
  ```

  See Autoalias.Conflicts module for more info about conflict cases.
  """

  alias Autoalias.Conflicts

  @doc "Macro for aliasing all accessible Elixir modules."
  defmacro __using__(_args) do
    :code.all_loaded()
    |> Enum.map(fn {module, _path} -> module end)
    |> Enum.filter(&elixir_module?/1)
    |> Conflicts.resolve()
    |> Enum.map(&quote_alias/1)
    |> quote_block()
  end

  # Returns true if given module is Elixir module, false when it's Erlang module like :code
  #
  @doc false
  defp elixir_module?(module) do
    match?("Elixir." <> _, Atom.to_string(module))
  end

  # Builds quoted alias
  #
  @doc false
  defp quote_alias(module) do
    {
      :alias,
      [context: Autoalias],
      [{:__aliases__, [alias: false], module}]
    }
  end

  # Builds quoted block
  #
  @doc false
  defp quote_block(aliases), do: {:__block__, [], aliases}
end
