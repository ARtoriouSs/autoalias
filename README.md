# Autoalias

Find yourself typing long module names when debugging something in iex?
Or creating aliases for lots of modules just to test simple query? This library can help you!

## Installation

Available via [Hex package](https://hex.pm/packages/autoalias), just add `autoalias` to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:autoalias, "~> 0.1.0", only: :dev}
  ]
end
```

## Usage

Simply type `use Autoalias` in the iex shell and it will ([try](#conflicts)) to alias every accessible module. For example:

**Before:**

```bash
iex -S mix phx.server
```

```elixir
iex(1)> MyApplication.Repo.get(MyApplication.SomeContext.SomeModule, 1) \
...(1)> |> MyApplication.SomeContext.SomeModule.changeset(%{foo: :bar}) \
...(1)> |> MyApplication.Repo.update()
```

**After:**

```bash
iex -S mix phx.server
```

```elixir
iex(1)> use Autoalias
iex(2)> Repo.get(SomeModule, 1) \
...(2)> |> SomeModule.changeset(%{foo: :bar}) \
...(2)> |> Repo.update()
```

_NOTE:_ you should **not** use it in your code, it's built only for simplifying iex experience.

Check out the [docs](https://hexdocs.pm/autoalias) for more info.

### Conflicts

