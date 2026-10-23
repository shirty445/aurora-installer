#!/bin/bash
# J604 Fedora entry point: usable from a checkout or directly through bash stdin.
# Parse the complete block before executing a piped download.
if true; then
set -euo pipefail

if [ "$(uname -s)" != Darwin ] || [ "$(uname -m)" != arm64 ]; then
 echo 'Run this installer in a native Apple Silicon macOS terminal.' >&2
 exit 1
fi

if [ -n "${BASH_SOURCE[0]:-}" ]; then
 installer_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 if [ -f "$installer_source/j604/install.sh" ]; then
  exec bash "$installer_source/j604/install.sh" "$@"
 fi
fi

xcode-select -p >/dev/null 2>&1 || {
 echo 'Install Apple Command Line Tools with xcode-select --install, then rerun this command.' >&2
 exit 1
}

installer_repo='https://github.com/shirty445/aurora-installer.git'
installer_checkout="${J604_INSTALLER_CHECKOUT:-$HOME/Library/Application Support/J604 Fedora Installer}"
if [ -e "$installer_checkout" ]; then
 [ -d "$installer_checkout/.git" ] || {
  echo "The installer cache is not a Git checkout: $installer_checkout" >&2; exit 1;
 }
 [ "$(git -C "$installer_checkout" remote get-url origin)" = "$installer_repo" ] || {
  echo 'The cached installer has a different origin; preserving it.' >&2; exit 1;
 }
 [ -z "$(git -C "$installer_checkout" status --porcelain)" ] || {
  echo 'The cached installer has local edits; preserving them.' >&2; exit 1;
 }
 [ "$(git -C "$installer_checkout" branch --show-current)" = fedora ] || {
  echo 'The cached installer is on another branch; preserving it.' >&2; exit 1;
 }
 git -C "$installer_checkout" pull --ff-only origin fedora
else
 mkdir -p "$(dirname "$installer_checkout")"
 git clone --depth=1 --single-branch --branch fedora "$installer_repo" "$installer_checkout"
fi
exec bash "$installer_checkout/j604/install.sh" "$@"
fi
