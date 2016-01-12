# Changes

- 0.3.2: merge [hykw](https://github.com/hykw)'s pull request fixing an issue when memcached gets down (and not crashing the whole app)
- 0.3.1: 
    - make memcached host/port configurable via Mix.Config (config.exs)
    - write a supervisor module with a memcached worker instead of just definig a worker to better handle memcached connection faults somewhen (not implemented yet, will faults simply  retsart the child)
- 0.2.7: Fix dependecy issue: Plug >=0.13 shall be OK
