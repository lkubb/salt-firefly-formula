# -*- coding: utf-8 -*-
# vim: ft=yaml
---
firefly:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: firefly
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/firefly
      compose: docker-compose.yml
      config_firefly: firefly.env
      config_db: db.env
      config_importer: importer.env
      data: data
      db: db
      export: export
    user:
      groups: []
      home: null
      name: firefly
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      db:
        image: docker.io/library/mariadb
      firefly:
        image: docker.io/fireflyiii/core:latest
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    allow_webhooks: false
    app:
      debug: false
      env: local
      key: null
      log_level: notice
      name: FireflyIII
      url: http://localhost
    audit_log_level: info
    authentication_guard: web
    authentication_guard_email: null
    authentication_guard_header: REMOTE_USER
    broadcast_driver: log
    cache:
      driver: file
      prefix: firefly
    cookie:
      domain: null
      path: /
      samesite: lax
      secure: false
    custom_logout_url: null
    db:
      connection: mysql
      database: firefly
      host: db
      password: null
      port: 3306
      socket: null
      username: firefly
    default_language: en_US
    default_locale: equal
    demo_password: null
    demo_username: null
    disable_csp_header: false
    disable_frame_header: false
    dkr_build_locale: false
    dkr_check_sqlite: true
    dkr_run_migration: true
    dkr_run_passport_install: true
    dkr_run_report: true
    dkr_run_upgrade: true
    dkr_run_verify: true
    enable_external_map: false
    firefly_iii_layout: v1
    ipinfo_token: null
    is_heroku: false
    log_channel: stack
    mail:
      encryption: null
      from: changeme@example.com
      host: null
      mailer: log
      password: null
      port: 2525
      username: null
    mailgun:
      domain: null
      endpoint: api.mailgun.net
      secret: null
    mandrill_secret: null
    map_default_lat: 51.983333
    map_default_long: 5.916667
    map_default_zoom: 6
    mysql:
      ssl_ca: null
      ssl_capath: /etc/ssl/certs/
      ssl_cert: null
      ssl_cipher: null
      ssl_key: null
      ssl_verify_server_cert: true
      use_ssl: false
    papertrail:
      host: null
      port: null
    psql:
      schema: public
      ssl_cert: null
      ssl_crl_file: null
      ssl_key: null
      ssl_mode: prefer
      ssl_root_cert: null
    pusher:
      id: null
      key: null
      secret: null
    queue_driver: sync
    redis:
      cache_db: '1'
      db: '0'
      host: redis
      password: null
      path: null
      port: 6379
      scheme: tcp
    send:
      error_message: true
      login_new_ip_warning: true
      registration_mail: true
      report_journals: true
    session_driver: file
    site_owner: mail@example.com
    sparkpost_secret: null
    static_cron_token: null
    tracker_site_id: null
    tracker_url: null
    trusted_proxies: []
    tz: Etc/UTC
  host_port: 7143

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://firefly/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   firefly-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Firefly III environment file is managed:
      - firefly.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
