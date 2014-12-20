Plug.Session.MEMCACHED
======================

This is a veeery simple memcached session store for Elixir's plug.

## Motivation: Why memcached when there's an ETS or Cookie store?

A short discussion: I am probably wrong.

### Cookies

While it's so great and simple to store session data in the cookie
itself, it has some downsides:

Data should be tamper-proof as they will be signed by your secret but one can
still see hwat data is in the cookie and even it was encrypted on can easiliy
see that there actually *is* session data as the cookie grows.

Apart from changing your session key there's no easy way to invalidate a certain
session cookie. For example: A user logs in and you assign the value "user",
<user_id> or soething like taht to you session data. Someone (possibly evil)
could record that cookie. When user logs out you might remive the user value
from the session. But if someone re-uses the old cookie (because he/she stole
it), your app might still think that user is logged in.

Of course, you could save login status in a database ... but I think one shouldn't

### ETS

Plug.Session.MEMCACHED.ETS solves the problem of cookies by only storing a
sesseion id in the cookie. But here goes the problem: If you application crashed
or you need to restart it, all session data is gone.

### DETS

Yeah, would be a nice option. But I like session data to be in-memory. When the
server crashes session data is gone anyways.

## So Memcached is best?

Certainly not for all purposes, but for mine. Pro: memcached is fast. I still
have to compare it against ETS (which I assume to be faster as one can spare the
TCP overhead) but for generall purpose it's very fast and should not be a
bottleneck.

Memcached service doesn't go away with you application. A thing that certainly
often happens in development. If you really watt to, you can delete all your
data just be restarting memcached. ETS or DETS would give you more options on
what data to delete.

All in all, storing session data in memcached seems to me like the best fit.