# cthullu/ansible

This repository contains the Dockerfile to build a small Ansible container image based on
Alpine Linux. This is another image whith the goal to provide a minimal footprint container.

In addition to the base Alpine OS and Ansible, a small number of selected Ansible roles
and/or collections is installed.

## Get the image

The latest image can pulled from quay.io:

    docker pull quay.io/cthullu/ansible
