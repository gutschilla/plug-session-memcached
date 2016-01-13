defmodule PlugSessionMemcached.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_session_memcached,
     version: "0.3.3",
     elixir: "~> 1.0",
     package: package,
     description: description,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     mod: {PlugSessionMemcached, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
    {:cowboy, "~> 1.0.0"},
    {:plug, ">= 0.13.0"},
    {:mcd, github: "EchoTeam/mcd"}, # memcached driver
    ]
  end

  defp description do
    """
    A memcached session store for use with Plug.Session
    """
  end
  
  defp package do
    [# These are the default files included in the package
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Martin Gutsch"],
     licenses: ["MIT"],
     links: %{
        "GitHub" => "https://github.com/gutschilla/plug-session-memcached"
        # "Docs" => "http://ericmj.github.io/postgrex/"
      }
     ]
  end
  
end
