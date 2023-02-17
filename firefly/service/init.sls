# vim: ft=sls

{#-
    Starts the firefly, db, importer container services
    and enables them at boot time.
    Has a dependency on `firefly.config`_.
#}

include:
  - .running
