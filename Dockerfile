# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
RUN apk --update-cache                                              \
        --no-cache                                                  \
        upgrade

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

# Install python pip to provide ARA integration
RUN apk add --no-cache                                              \
        py3-pip

# Install bind-tools, git, and openssh
RUN apk add --no-cache                                              \
        bind-tools                                                  \
        git                                                         \
        openssh

# Install ca-certificates and sudo package to update CA store
RUN apk add --no-cache                                              \
        ca-certificates                                             \
        sudo

# Clear apk cache
RUN rm -rf /var/cache/apk/*

# Create a Ansible group and user
# Set user- and groupID to 1500
RUN addgroup --gid 1500 ansible                                     \
    && adduser --uid 1500 -D -G ansible ansible

# Copy sudoers configuration snippet, adapt rights and check syntax just in case
COPY --chown=root:root ./data/sudoers /etc/sudoers.d/entryscript
RUN chmod 0640 /etc/sudoers.d/entryscript                           \
    && visudo -c /etc/sudoers.d/entryscript

# Create Ansible folder and adapt permissions
RUN mkdir -p /etc/ansible                                           \
    && chown -R ansible:ansible /etc/ansible                        \
    && chmod 0755 /etc/ansible

RUN mkdir -p /tmp/certs                                             \
    && chown ansible:ansible /tmp/certs                             \
    && chmod 770 /tmp/certs

# Create mount points with the specified names and mark them as holding external provided volumes
VOLUME [ "/etc/ansible", "/tmp/certs" ]

######
RUN apk add --no-cache sudo openssl

# Switch to dedicated Ansible user
USER ansible

# Provide ARA in userspace
RUN python3 -m pip install --user --upgrade --no-cache-dir ara

# Copy the entrypoint script
COPY --chown=ansible:ansible ./data/entrypoint.sh /home/ansible/entrypoint.sh

# Change permissions of script to someting more reasonable
RUN chmod 640 /home/ansible/entrypoint.sh

# TODO:
# * Dynamicaly handle additional roles          -> entrypoint script
# * Dynamicaly handle additional collections    -> entrypoint script

# Install fedora.linux_system_roles collection
RUN ansible-galaxy collection install fedora.linux_system_roles

WORKDIR /etc/ansible

ENTRYPOINT [ "/usr/bin/env", "sh" , "/home/ansible/entrypoint.sh" ]
