# vim: ft=sls

{#-
    *Meta-state*.

    This installs the firefly, db, importer containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
