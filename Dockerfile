# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
# Install Ansible and ansible-lint
# Install nice to have python packages to extend Ansible and Ansible-lint functionality
# Install python pip to provice ARA integration
RUN apk --update-cache                                              \
        --no-cache                                                  \
        upgrade                                                     \
    && apk add --no-cache                                           \
        ansible                                                     \
        ansible-lint                                                \
        py3-dnspython                                               \
        py3-jmespath                                                \
        py3-netaddr                                                 \
        py3-pip                                                     \
        py3-xmltodict                                               \
        yamllint                                                    \
    && rm -rf /var/cache/apk/*

# Provide ARA
RUN python3 -m pip install --upgrade --no-cache-dir ara

# Create a Ansible group and user
RUN addgroup -S ansible                                             \
    && adduser -S -D -G ansible ansible

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

# Install custom roles from the linux-system-roles namespace
RUN ansible-galaxy install linux-system-roles.network               \
    && ansible-galaxy install linux-system-roles.crypto_policies    \
    && ansible-galaxy install linux-system-roles.firewall           \
    && ansible-galaxy install linux-system-roles.kdump              \
    && ansible-galaxy install linux-system-roles.kernel_settings    \
    && ansible-galaxy install linux-system-roles.network

WORKDIR /etc/ansible
