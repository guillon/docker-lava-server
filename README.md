LAVA Server image for LAVA at http://www.linaro.org
===================================================

Installs lava-server from images.validation.linaro.org repository.

Usage
=====

In order to access the lava-server http service, one may at least
bind the port 80, for instance run this image with:

    $ docker run --name lava-server -d -p 8080:80 guillon/lava-server

and browse lava-server at http://localhost:8080.

A local admin account is available with login / password: admin / changeit

Implementation
==============

Refer to comments in the Dockerfile at
https://github.com/guillon/docker-lava-server/blob/master/Dockerfile

References
==========

Sources at: https://github.com/guilon/lava-server.

For LAVA installation documentation, refer to:

- http://www.linaro.org/
- https://porter.automotivelinux.org/static/docs/v2/
- https://porter.automotivelinux.org/static/docs/v2/installing_on_debian.html

Legal
=====

Distributed as is under the MIT licence.

Copyright (C) STMicroelectronics 2016.


