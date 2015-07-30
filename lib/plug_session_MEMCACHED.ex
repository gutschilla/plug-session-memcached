defmodule Plug.Session.MEMCACHED do
    @moduledoc """
    Stores the session in a memcached instance.

    ## Vserion 0.3

    * 0.3 - switch to :merle in favour of :mcd as I could not convince :mcd.startlink() not to raise an error when started in a release(?)
    * 0.2 - change arities of delete, get, put to match phoenix 0.5.0

    An established MEMCACHED connection instance via mcd is required for this
    store to work.

    This store does not create the MEMCACHED connection, it is expected that an
    existing named connection is given as argument with  public properties.

    ## Options

    none.

    ## Examples

    # Creatememcached connection on application start, we'll call this process
    # memcached_sessions (use what you like)
    :merle.connect()

    # Use the session plug with the connection process name
    key = "myapp_session_id"
    plug Plug.Session,  store: :memcached, key: key


    See:
    https://github.com/joewilliams/merle/blob/master/src/merle.erl

    ## Acknowledgements
    This module is based on Plug.Session.Store.ETS
    Most parts are just copied from there and adapted to :merle instead of :ets.
    """

    @behaviour Plug.Session.Store

    @max_tries 100

    def init(opts) do
      # Keyword.fetch!(opts, :table)
    end

    def get( _conn, sid) do
        case :mcd.getkey( sid ) do
          :undefined -> { nil, %{} }
          data       -> { sid, data }
        end
    end

    def put( _conn, nil, data) do
        put_new(data)
    end

    def put( _conn, sid, data) do
        :merle.set( sid, data )
    sid
    end

    def delete( _conn, sid) do
        :merle.delete(sid)
        :ok
    end

    defp put_new(data, counter \\ 0)
        when counter < @max_tries do
            sid = :crypto.strong_rand_bytes(96) |> Base.encode64
        put( nil, sid, data )
    end
end
