Plug.Session.MEMCACHED
======================

This is a very simple memcached session store for Elixir's plug. I use it in
conjunction with the great
[Phoenix Framework](https://github.com/phoenixframework/phoenix).

## Synopsis

Add these to your project's `mix.exs`:
```
# will create a mcd connection to memcached as :memcached_sessions
def application do
  [
    ...
    applications: [
        ...
        :plug_session_memcached # <--- add this entry
    ]
  ]
end

# add dependency
defp deps do
  [
    ...
    {:plug_session_memcached, "~> 0.3.1" }, # <-- add this entry
    {:mcd, github: "EchoTeam/mcd"}          # <-- and this one 
  ]
end
```

You may want to alter the standard memcached host/port in your `config.exs` (or `dev.exs` or `prod.exs`). If no config is given, host `127.0.0.1` and port `11211` is used:
```
# be sure to use a binary for the host the underlying memcached connector is written in Erlang)
# server: [ <host_binary>, <port_integer> ]
config :plug_session_memcached,
  server: [ '127.0.0.1', 11211 ]
```

Be sure to manually include :mcd as hex won't fetch github dependencies
automatically for you. At some point I might switch to tsharju's
:memcache_client which should do the same.

Then use the plug
```
plug Plug.Session,
  store: :memcached,
  key: "_my_app_key", # use a proper value 
  table: :memcached_sessions, # <-- this on is hard coded into the plug
  signing_salt: "123456",   # use a proper value
  encryption_salt: "654321" # use a proper value
```

In phoenix (version 1.0 and above), add the lines above to your lib/enpoint.ex

## TODO

 [x] Add tests: create a small service with Cowboy answering http request with some session data in them.
 [x] Let memcached server/port be configurable from config.exs
 [ ] Add proper docs

## Motivation: Why Memcached when there's an ETS or Cookie store?
A short discussion: I am probably wrong.

### Cookies
While it's so great and simple to store session data in the cookie
itself, it has some downsides:

Even when the cookie is encrypted and signed, there is still some information 
about the size of information stored in it.

Apart from changing your session key there's no easy way to invalidate a certain
session cookie. For example: A user logs in and you assign the value "user_id",
<user_id> to your session data. Someone could record that cookie and simply re-use it. 

IMHO the server should be the single source of truth for login states.
### ETS
Plug.Session.MEMCACHED.ETS solves the problem of cookies by only storing a
session id in the cookie. But it's hard to access from outside of you App and 
if your app needs to restart all your session data is lost which doesn't come 
handy in development or production (unless hotcode reoad is your cup of tea).

### DETS
Yeah, would be a nice option. But I like session data to be in-memory. When the
server crashes session data is gone anyways.

## So Memcached is best?
Certainly not for all purposes, but for mine. Pro: memcached is fast. I still
have to compare it against ETS (which I assume to be faster as one can spare the
TCP overhead) but for generall purpose it's very fast and should not be a
bottleneck.

Memcached service doesn't go away with your application. A thing that certainly
often happens in development. If you really want to, you can delete all your
data just be restarting memcached. ETS or DETS would give you more options on
what data to delete.

All in all, storing session data in memcached seems to me like the best fit.

