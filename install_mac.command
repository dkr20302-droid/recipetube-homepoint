#!/bin/bash
set -euo pipefail

# RecipeTube macOS installer helper.
# Downloads RecipeTube.dmg from a URL you provide, then opens it in Finder.
#
# Usage:
#   ./install_mac.command https://YOUR_DOWNLOADS_HOST
# Example:
#   ./install_mac.command https://xxxxx.trycloudflare.com
#
# The host must serve:
#   /downloads/RecipeTube.dmg

BASE_URL="${1:-}"
if [[ -z "$BASE_URL" ]]; then
  echo ""
  echo "Usage: $(basename "$0") https://YOUR_DOWNLOADS_HOST"
  echo "Example: $(basename "$0") https://xxxxx.trycloudflare.com"
  echo ""
  read -r -p "Press Enter to exit..."
  exit 1
fi

# Trim trailing slash
BASE_URL="${BASE_URL%/}"

DMG_URL="${BASE_URL}/downloads/RecipeTube.dmg"
OUT_DMG="${TMPDIR%/}/RecipeTube.dmg"

echo "Downloading RecipeTube DMG..."
echo "  ${DMG_URL}"
echo "  -> ${OUT_DMG}"
echo ""

if command -v curl >/dev/null 2>&1; then
  curl -L --fail --retry 3 --retry-delay 1 -o "${OUT_DMG}" "${DMG_URL}"
elif command -v wget >/dev/null 2>&1; then
  wget -O "${OUT_DMG}" "${DMG_URL}"
else
  echo "Error: curl or wget is required."
  read -r -p "Press Enter to exit..."
  exit 1
fi

SIZE_BYTES="$(stat -f%z "${OUT_DMG}" 2>/dev/null || stat -c%s "${OUT_DMG}")"
if [[ "${SIZE_BYTES}" -lt 10000000 ]]; then
  echo "Error: downloaded file looks too small (${SIZE_BYTES} bytes)."
  read -r -p "Press Enter to exit..."
  exit 1
fi

echo "Opening DMG..."
open "${OUT_DMG}"

echo ""
echo "Done."
echo "In Finder, drag RecipeTube into Applications."
read -r -p "Press Enter to close..."

