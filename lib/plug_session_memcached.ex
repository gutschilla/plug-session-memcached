defmodule PlugSessionMemcached do
  use Application

@vsn "0.3.3"
    
  @moduledoc """
  This plug is to be used as store for Plug.Session. It saves session data in
  a memcached instance providing just a session id being saved in the user's 
  cookie. 

  Provides Plug.Session.MEMCACHED
  
  ## Usage
   1. Configure the connection to a memcached instance:
      ```
      config :plug_memcached_sessions, ['127.0.0.1', 11211 ]
      ```
  2. In your app, use and configure Plug.Session
     ```
     plug Plug.Session,
       store: :memcached,
       key: "_my_app_key", # use a proper value 
       table: :memcached_sessions, # <-- this on is hard coded into the plug
       signing_salt: "123456",   # use a proper value
       encryption_salt: "654321" # use a proper value
     ```
  
  ## Limitations
  
  Maximum session data size is 1MB. Be aware that this one MB is the size of 
  the serialized data. Data serialization is done via Erlang's 
  `term_to_binary(Data)` (see [mcd](https://github.com/EchoTeam/mcd/blob/master/src/mcd.erl#L715))
  
  """

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
  
  def init _arg do
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
