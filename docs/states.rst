Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``firefly``
^^^^^^^^^^^
*Meta-state*.

This installs the firefly, db, importer containers,
manages their configuration and starts their services.


``firefly.package``
^^^^^^^^^^^^^^^^^^^
Installs the firefly, db, importer containers only.
This includes creating systemd service units.


``firefly.config``
^^^^^^^^^^^^^^^^^^
Manages the configuration of the firefly, db, importer containers.
Has a dependency on `firefly.package`_.


``firefly.service``
^^^^^^^^^^^^^^^^^^^
Starts the firefly, db, importer container services
and enables them at boot time.
Has a dependency on `firefly.config`_.


``firefly.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``firefly`` meta-state
in reverse order, i.e. stops the firefly, db, importer services,
removes their configuration and then removes their containers.


``firefly.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the firefly, db, importer containers
and the corresponding user account and service units.
Has a depency on `firefly.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``firefly.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the firefly, db, importer containers
and has a dependency on `firefly.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``firefly.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the firefly, db, importer container services
and disables them at boot time.


