# cthullu/ansible

This repository contains the Dockerfile to build a small Ansible container image based on
Alpine Linux. This is another image whith the goal to provide a minimal footprint container.

## Content of the Image

In addition to the base Alpine OS and Ansible and ARA, the Ansible linux-system-roles
collections is installed.

Furthermore, the following packages are installed:

* bind-utils
* git
* openssh

## Get the image

The latest image can pulled from quay.io:

    docker pull quay.io/cthullu/ansible
