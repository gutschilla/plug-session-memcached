Plug.Session.MEMCACHED
======================

This is a very simple memcached session store for Elixir's plug. I use it in
conjunction with the great
[Phoenix Framework](https://github.com/phoenixframework/phoenix).

## Synopsis

Add thi to your mixfile:

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
    {:plug_session_memcached, "~> 0.2.0" } # <-- add this entry
    
  ]
end
```

Then use the plug
```
plug Plug.Session,
  store: :memcached,
  key: "_my_app_key", # use a proper value 
  table: :memcached_sessions, # <-- this on is hard coded into the plug
  signing_salt: "123456",   # use a proper value
  encryption_salt: "654321" # use a proper value
```

In phoenix (version 0.7.2 and above), add the lines above to your lib/enpoint.ex

## TODO

 - [ ] Add tests: create a small service with Cowboy answering http request with some session data in them.
 - [ ] Let memcached server/port be configurable from config.exs
 - [ ] Add proper docs

## Motivation: Why Memcached when there's an ETS or Cookie store?

A short discussion: I am probably wrong.

### Cookies

While it's so great and simple to store session data in the cookie
itself, it has some downsides:

Even when the cookie is encrypted and signed, there is still some information 
about the size of information stored in it.

Apart from changing your session key there's no easy way to invalidate a certain
session cookie. For example: A user logs in and you assign the value "user_id",
<user_id> to your session data. Someone could record that cookie. 

When the user logs out all that happens is that the cookie now says user_id: nil.

When you (or some evil guy who recorded that cookie) manually set the cookie data to 
the previous encrypted string => you're logged in again because the server which
IMHO should be the single point of truth has no records of who's logged in or not.

Of course, you could save login status in a database ... but I think one shouldn't.

### ETS

Plug.Session.MEMCACHED.ETS solves the problem of cookies by only storing a
session id in the cookie. But here goes the problem: If you application crashed
or you need to restart it, all session data is gone. Maybe this is a relict of
my old stateless HTTP thinking.

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

