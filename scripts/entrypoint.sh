#!/usr/bin/env sh

ACTIVATE_ARA_ENV="${ACTIVATE_ARA_ENV:=false}"

if [[ ${ACTIVATE_ARA_ENV} == "true" ]]; then
  export ANSIBLE_ACTION_PLUGINS="$(python3 -m ara.setup.action_plugins)"
  export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"
  export ANSIBLE_LOOKUP_PLUGINS="$(python3 -m ara.setup.lookup_plugins)"
fi
