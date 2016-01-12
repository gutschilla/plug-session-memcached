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
      # worker( :mcd, [ :memcached_sessions, [ '127.0.0.1', 11211 ] ] )
      supervisor( PlugSessionMemcached.Supervisor, [] )
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugSessionMemcached.Supervisor]
    { :ok, _pid } = Supervisor.start_link(children, opts)
  end

end

defmodule PlugSessionMemcached.Supervisor do
  use Supervisor

  def start_link arg \\ [] do
    Supervisor.start_link __MODULE__, arg
  end
  
  def init arg do
    children = [
      worker( :mcd, [
          :memcached_sessions,
          Application.get_env( :plug_session_memcached, :server  ) || [ '127.0.0.1', 11211 ],
        ]
      )
    ]
    supervise children, strategy: :one_for_one
  end

end
