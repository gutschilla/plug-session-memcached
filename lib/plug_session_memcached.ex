defmodule PlugSessionMemcached do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # start memcached for sessions
    # :mcd.start_link(:memcached_sessions, [] )

    children = [
      # Define workers and child supervisors to be supervised
      # worker(PlugSessionMemcached.Worker, [arg1, arg2, arg3])
      worker( :mcd, [ :memcached_sessions, [ '127.0.0.1', 11211 ] ] )
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugSessionMemcached.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
