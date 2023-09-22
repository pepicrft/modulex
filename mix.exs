defmodule ApplicationModule.MixProject do
  use Mix.Project

  @version "0.4.0"

  def project do
    [
      app: :modulex,
      version: @version,
      elixir: "~> 1.15",
      description:
        "Generate a module whose implementation can be swapped at runtime with tools like Mox.",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:boundary, "~> 0.10", runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      name: "modulex",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/glossia/modulex"}
    ]
  end

  defp docs() do
    [
      main: "modulex",
      extras: ["README.md"],
      source_url: "https://github.com/glossia/modulex/",
      source_ref: @version
    ]
  end
end
