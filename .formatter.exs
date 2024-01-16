[
  plugins: [Absinthe.Formatter],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:absinthe, :ecto, :ecto_sql, :phoenix],
  subdirectories: ["priv/*/migrations"]
]
