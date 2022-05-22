[
  import_deps: [:ecto, :ecto_sql, :phoenix, :surface],
  inputs: ["*.{ex,exs}", "{config,lib,test,priv}/**/*.{ex,exs}"],
  surface_inputs: ["{lib,test}/**/*.{ex,exs,sface}", "priv/catalogue/**/*.{ex,exs,sface}"]
]
