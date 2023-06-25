# Set base image for following commands
FROM alpine:edge

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
RUN apk --update-cache                                              \
        --no-cache                                                  \
        upgrade

# Install bind-tools, git, openssh and bash
RUN apk add --no-cache                                              \
        bind-tools                                                  \
        git                                                         \
        openssh                                                     \
        bash

# Install Ansible and ansible-lint
RUN apk add --no-cache                                              \
        ansible                                                     \
        ansible-lint

# Install additional packages to extend Ansible and Ansible-lint functionality
RUN apk add --no-cache                                              \
        black                                                       \
        py3-dnspython                                               \
        py3-jmespath                                                \
        py3-netaddr                                                 \
        py3-xmltodict                                               \
        yamllint

# Clear apk cache
RUN rm -rf /var/cache/apk/*

# Create a Ansible group and user
# Set user- and groupID to 1500
RUN addgroup --gid 1500 ansible                                     \
    && adduser -s /bin/bash -G ansible -D -u 1500 ansible

# Create Ansible folder and adapt permissions
RUN mkdir -p /etc/ansible                                           \
    && chown -R ansible:ansible /etc/ansible                        \
    && chmod 0755 /etc/ansible

# Create mount points with the specified names and mark them as holding external provided volumes
VOLUME [ "/etc/ansible" ]

# Switch to dedicated Ansible user
USER ansible

# Create user ssh config folder
RUN mkdir /home/ansible/.ssh                                       \
  && chown ansible:ansible /home/ansible/.ssh                      \
  && chmod 0700 /home/ansible/.ssh

# Copy the user bashrc and ssh config file
COPY --chown=ansible:ansible ./data/bashrc /home/ansible/.bashrc
COPY --chown=ansible:ansible ./data/ssh_config /home/ansible/.ssh/config

# Adapt ssh config file and bashrc permissions
RUN chmod 0600 /home/ansible/.ssh/config

WORKDIR /etc/ansible

CMD [ "sleep", "infinity" ]
