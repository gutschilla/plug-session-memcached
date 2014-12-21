defmodule PlugSessionMemcached.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_session_memcached,
     version: "0.2.2",
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
    {:plug, "~> 0.9.0"},
    {:mcd, github: "EchoTeam/mcd"}, # memcached driver
    ]
  end

  defp description do
    """
    This is a very simple memcached session store for Elixir's plug. I use it in conjunction with the great
    [Phoenix Framework](https://github.com/phoenixframework/phoenix).
    """
  end
  
  defp package do
    [# These are the default files included in the package
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     contributors: ["Martin Gutsch"],
     licenses: ["MIT"],
     #links: %{"GitHub" => "https://github.com/ericmj/postgrex",
     #         "Docs" => "http://ericmj.github.io/postgrex/"}
     ]
  end
  
end
