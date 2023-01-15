#!/usr/bin/env bash

set -euo pipefail

# Add custom certificates to local CA-store
#if [[ $(ls /tmp/certs/ | wc -w) -gt 0 ]]; then
#  sudo cp /tmp/certs/*.crt /usr/local/share/ca-certificates/
#  sudo update-ca-certificates

  # Also, tell python to use the system cert store, instead of his own
#  export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
#fi
