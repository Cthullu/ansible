# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
RUN apk --update-cache                                              \
        --no-cache                                                  \
        upgrade                                                     \
# Install Ansible and ansible-lint
    && apk add --no-cache                                           \
        ansible                                                     \
        ansible-lint                                                \
# Install nice to have python packages to extend Ansible and Ansible-lint functionality
    && apk add --no-cache                                           \
        py3-dnspython                                               \
        py3-jmespath                                                \
        py3-netaddr                                                 \
        py3-xmltodict                                               \
        yamllint                                                    \
# Install python pip to provice ARA integration
    && apk add --no-cache                                           \
        py3-pip                                                     \
# Install bind-tools, git, and openssh
    && apk add --no-cache                                           \
        bind-tools                                                  \
        git                                                         \
        openssh                                                     \
    && rm -rf /var/cache/apk/*

# Provide ARA
RUN python3 -m pip install --upgrade --no-cache-dir ara

# Create a Ansible group and user
# Set user- and groupID to 1500
RUN addgroup --gid 1500 ansible                                     \
    && adduser --uid 1500 -D -G ansible ansible

# Create folder and adapt permissions
RUN mkdir -p /etc/ansible                                           \
    && chown -R ansible:ansible /etc/ansible                        \
    && chmod 0755 /etc/ansible

# Create mount points with the specified names and mark them as holding external provided volumes
VOLUME [ "/etc/ansible" ]

# Switch to dedicated Ansible user
USER ansible

# TODO:
# * Dynamicaly handle additional roles          -> entrypoint script
# * Dynamicaly handle additional collections    -> entrypoint script

# Install fedora.linux_system_roles collection
RUN ansible-galaxy collection install fedora.linux_system_roles

WORKDIR /etc/ansible
