# Set base image for following commands
FROM alpine:3.17.1

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
RUN apk --update-cache                                              \
        --no-cache                                                  \
        upgrade

# Install bind-tools, git, and openssh
RUN apk add --no-cache                                              \
        bind-tools                                                  \
        git                                                         \
        openssh

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

# Clear apk cache
RUN rm -rf /var/cache/apk/*

# Create a Ansible group and user
# Set user- and groupID to 1500
RUN addgroup --gid 1500 ansible                                     \
    && adduser --uid 1500 -D -G ansible ansible

# Create Ansible folder and adapt permissions
RUN mkdir -p /etc/ansible                                           \
    && chown -R ansible:ansible /etc/ansible                        \
    && chmod 0755 /etc/ansible

# Copy profile.d scripts
COPY --chown=root:root ./data/profile.d /etc/profile.d/

# Ensure 0644 are set as permissions for profile.d scripts
RUN chmod 0644 /etc/profile.d/*

# Create mount points with the specified names and mark them as holding external provided volumes
VOLUME [ "/etc/ansible" ]

# Switch to dedicated Ansible user
USER ansible

# Provide ARA in userspace
RUN python3 -m pip install --user --upgrade --no-cache-dir ara

# TODO:
# * Dynamicaly handle additional roles          -> entrypoint script
# * Dynamicaly handle additional collections    -> entrypoint script

# Install fedora.linux_system_roles collection
RUN ansible-galaxy collection install fedora.linux_system_roles

# Create user ssh config folder
RUN mkdir /home/ansible/.ssh                                       \
  && chown ansible:ansible /home/ansible/.ssh                      \
  && chmod 0700 /home/ansible/.ssh

# Copy the user ssh config file
COPY --chown=ansible:ansible ./data/ssh_config /home/ansible/.ssh/config

# Adapt ssh config file permissions
RUN chmod 0600 /home/ansible/.ssh/config

# Disable git ssl verify
# (Ugly, but avoid errors if e.g., self signed ssl certs in chain)
ENV GIT_SSL_NO_VERIFY=true

WORKDIR /etc/ansible

CMD [ "sleep", "infinity" ]
