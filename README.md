# cthullu/ansible

This repository contains the Dockerfile to build a small Ansible container image based on
Alpine Linux. This is another image whith the goal to provide a minimal footprint container.

## Content of the Image

In addition to the base Alpine OS and Ansible and ARA (client), the Ansible
linux-system-roles collections is installed.

Furthermore, the following packages are installed:

* bind-utils
* git
* openssh

## Environment Variables

By default, no ARA environment (action, callback and loopback plugins) are laoded.
If desired, the container can be started with the environment set up to know those plugins.

Therefore, pass `ACTIVATE_ARA_ENV=true` during the container invokation.

## Custom Certificates

Custom certificates, which should be added to the system trusted CA store, can be mounted
to `/tmp/certs/`. The certificates stored at this location are copied and added to the
system CA store. Only files ending with .crt will be copied.

## Changes starting with 6.6.0-b3

Starting with image version 6.6.0-b3 I decided to make some changes in the general image
layout:

* Split big `RUN` blocks into smaller blocks to increase debugbility.
* Changed order of pakcage installation
* Add proper entrypoint script
* Add python packages in user context

This changes add more layers to the image, but in my opinion increase the read- and
maintainability of the project in the long run.

## Get the image

The latest image can pulled from quay.io:

    docker pull quay.io/cthullu/ansible
