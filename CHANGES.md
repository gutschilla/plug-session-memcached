# Changes

- 0.3.0: 
    - make memcached host/port configurable via Mix.Config (config.exs)
    - write a supervisor module with a memcached worker instead of just definig a worker to better handle memcached connection faults somewhen (not implemented yet, will faults simply  retsart the child)
- 0.2.7: Fix dependecy issue: Plug >=0.13 shall be OK
