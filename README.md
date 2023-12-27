# cthullu/ansible

This repository contains the Dockerfile to build a small Ansible container image
based on Alpine Linux. This is another image whith the goal to provide a minimal
footprint container.

## Content of the Image

In addition to the base Alpine OS and Ansible and ARA (client), the Ansible
linux-system-roles collections is installed.

Furthermore, the following packages are installed:

* bind-utils
* git
* openssh

## Environment Variables

By default, no ARA environment (action, callback and loopback plugins) are
laoded. If desired, the container can be started with the environment set up to
know those plugins.

Therefore, pass `ACTIVATE_ARA_ENV=true` during the container invokation.

## Custom Certificates

:info: Disabled at 6.6.0-b4

Custom certificates, which should be added to the system trusted CA store, can
be mounted to `/tmp/certs/`. The certificates stored at this location are copied
and added to the system CA store. Only files ending with .crt will be copied.

## Changes starting with 6.6.0-b3

Starting with image version 6.6.0-b3 I decided to make some changes in the
general image layout:

* Split big `RUN` blocks into smaller blocks to increase debugbility.
* Changed order of package installation
* Add proper entrypoint script
* Add python packages in user context

This changes add more layers to the image, but in my opinion increase the read-
and maintainability of the project in the long run.

## Changes made with 6.6.0-b4

I removed the entrypoint script (and thus the custom certificate support) for
the moment. Before implementing this again, there is some homework to do from my
side, how to work effectively with entrypoint scripts.

Aa an alternative, the SSL verification is disabled for GIT commands, so it
still works with repositories with unknown/untrusted CA chains.

I also decided to disable the StrictHostKey checking from ssh to avoid the
annoying SSH key verification for every git command using ssh.

Well, and finally I decided to move away from the default shell and use bash
instead. While this may conflict with the basic idea of the image (a minimal and
slim container providing just Ansible), I encountered various challenges trying
to use the default shell. So for the moment I am going to use the bash instead.

## Changes made with 6.6.0-b5

I moved away from bash again since I managed to get the environment set with the
Alpine Linux default shell. Still, the custom certificate support is missing,
but I'm starting to get closer to understanding the behaviour of Alpine Linux,
so I expect the feature to come again in one of the next releases.

## Roadmap

Well, with the release of `6.6.0-b5` I am somehow close to my original goal. As
of now, there are only two things left on my roadmap for this container project,
which I wanted to share:

* Custom CA certificate support
* Handling of additional Ansible roles and collections

As you most likely noticed, there is no date next to any of this features. This
is simply due to the fact that I work on this project entirely in my free time,
so features and new releases come as I get to work on them.

## Get the image

The latest image can pulled from quay.io:

~~~shell
docker pull quay.io/cthullu/ansible
~~~

## How to use

To make use of the Ansible provided by the image, I personally use two steps:

1. Start the container without any further commands

~~~shell
podman container run --detach --name ansible quay.io/cthullu/ansible:latest
~~~

2. Attach to the running container, activating ARA

~~~shell
podman exec -it -e ACTIVATE_ARA_ENV=true ansible sh --login
~~~
