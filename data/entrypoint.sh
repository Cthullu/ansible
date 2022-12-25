#!/usr/bin/env sh

ACTIVATE_ARA_ENV="${ACTIVATE_ARA_ENV:=false}"

# Add ARA plugin paths to environment
if [[ ${ACTIVATE_ARA_ENV} == "true" ]]; then
  export ANSIBLE_ACTION_PLUGINS="$(python3 -m ara.setup.action_plugins)"
  export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"
  export ANSIBLE_LOOKUP_PLUGINS="$(python3 -m ara.setup.lookup_plugins)"
fi

# Add custom certificates to local CA-store
if [[ $(ls /tmp/certs/ | wc -w) -gt 0 ]]; then
  sudo cp /tmp/certs/*.crt /usr/local/share/ca-certificates/
  sudo update-ca-certificates
fi

/usr/bin/env sh -l
