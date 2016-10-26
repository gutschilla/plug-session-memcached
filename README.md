Plug.Session.MEMCACHED
======================
A  memcached session store for Elixir's plug. 

## Description

Provides the application :plug_session_memcahed to be 
included in your app. This will create connection to 
a memcached server instance. Then, you may use the plug
`Plug.Session.MEMCACHED`, presumably in a Phoenix endpoint.

## Support
I use it in conjunction with the great [Phoenix Framework](https://github.com/phoenixframework/phoenix). If you encounter any issues, I'll be glad if you gave me notice.

## Synopsis
Add these to your project's `mix.exs`:
Adding both `:lager` and `:corman` to your `applications` section is required to make thing work if you plan to create a release with the great [exrm](https://github.com/bitwalker/exrm) tool. Also make sure to add the plug to `included_applications`.

```
# will create a mcd connection to memcached as :memcached_sessions
def application do
  [
    ...
    applications: [
        ...
       :lager, :corman # <-- add these both (mcd needs them)
    ],
    included_applications: [
        :plug_session_memcached # <--- add this entry
    ]
  ]
end

# add dependency
defp deps do
  [
    ...
    {:plug_session_memcached, "~> 0.3.3" }, # <-- add this entry
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

In phoenix (version 1.0 and above), add the lines above to your `lib/<yourapp>/endpoint.ex`. For an example, see [endpoint.ex in my skeleton app repo](https://github.com/gutschilla/phoenix-skeleton/blob/master/lib/skeleton/endpoint.ex)

## Motivation: Why Memcached when there's an ETS or Cookie store?
A short discussion: I am probably wrong. 

I am using memcached for session storage for over a decade now in conjunction with many languages and web frameworks. And it just works great:

- for me, memcached is battle-proven. Not a single issue in a decade
- support for memcached server clusters (mcd apparently doesn't support this)
- 1MB of session storage (default memcached bucket size) as long `:erlang.term_to_binary(<your_session_data>)` fits in a megabyte
- no need for a distributed erlang setup in a load-balanced scenario: sessions are like a database on a single-purpose machine.

### Downside of Cookies
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
session id in the cookie. But it's hard to access from outside of your App and 
if your app needs to restart all your session data is lost which doesn't come in
handy in development or production (unless hot code reloading is your cup of tea).

### DETS
Yeah, would be a nice option. But I like session data to be in-memory. When the
server crashes session data is gone anyways.

## So Memcached is best?
Certainly not for all purposes, but for mine. Pro: memcached is fast. I still
have to compare it against ETS (which I assume to be faster as one can spare the
TCP overhead) but for general purpose it's very fast and should not be a
bottleneck.

Memcached service doesn't go away with your application. A thing that certainly
often happens in development. If you really want to, you can delete all your
data just be restarting memcached. ETS or DETS would give you more options on
what data to delete.

All in all, storing session data in memcached seems to me like the best fit.

