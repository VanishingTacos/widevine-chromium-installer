#!/bin/bash
set -e

SOCK=/workspace/tailscale/tailscaled.sock

echo "[INFO] Waiting for tailscaled to become ready..."
until tailscale --socket="$SOCK" status --json 2>/dev/null | grep -q '"BackendState"'; do
  sleep 1
done
echo "[INFO] tailscaled is ready!"

if tailscale --socket="$SOCK" status --json | grep -q 'NeedsLogin'; then
  echo "[INFO] Logging in..."
  tailscale --socket="$SOCK" up --authkey="$TS_AUTHKEY" --ssh
  echo "[INFO] Done."
else
  echo "[INFO] Already connected."
fi