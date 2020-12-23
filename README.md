# Autoalias

[![Hex Version](https://img.shields.io/hexpm/v/autoalias.svg)](https://hex.pm/packages/autoalias)

Find yourself typing long module names when debugging something in iex?
Or creating aliases for lots of modules just to test simple query? This library can help you!

_NOTE:_ you'll probably want to use `.iex.exs` file instead in most cases.

## Installation

Available via [Hex package](https://hex.pm/packages/autoalias), just add `autoalias` to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:autoalias, "~> 0.2.0", only: :dev}
  ]
end
```

## Usage

Simply type `use Autoalias` in the iex shell and it will ([try](#conflicts)) to alias every accessible module.
For example:

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

If we have several modules with the same ending and alias all of them, only last one will be accepted.
For this lib it will be the longest accessible module with particular ending, all others will be aliased
by their parents. Conflicts solving performs recursively till there will be no conflict at all.

For example if there is modules like `Foo.Bar.SomeModule` and `Baz.Qux.Corge.SomeModule` it will alias the longest module,
and closest parent for all conflicted modules. In this case it will be:

```elixir
alias Baz.Qux.Corge.SomeModule
alias Foo.Bar
```

So we can now use `SomeModule` to access first one and `Bar.SomeModule` for the second.

Here is the corner case when conflict appears with one-word module, e.g. `SomeModule` and `MyApp.SomeModule`.
In this case it will create alias for `MyApp.SomeModule` and you will loose direct access to one-word `SomeModule`
module. If this happened, you can prepend module with `Elixir.` prefix, like `Elixir.SomeModule`, to access it.
`Elixir` module itself cannot be aliased at all.

This cases are pretty rare, but it can happen.

## Contributing

If there is any problems or suggestions, you can always open [issue](https://github.com/ARtoriouSs/autoalias/issues)
or [pull request](https://github.com/ARtoriouSs/autoalias/pulls).
