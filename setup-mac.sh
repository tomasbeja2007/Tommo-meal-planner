#!/usr/bin/env bash
# One-command setup on a Mac: installs XcodeGen if needed, generates
# Forkcast.xcodeproj from project.yml and opens it in Xcode.
# Re-run it whenever project.yml changes or files are added/removed.
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v xcodegen >/dev/null 2>&1; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "XcodeGen is missing and Homebrew isn't installed."
    echo "Install Homebrew from https://brew.sh, then run this script again."
    exit 1
  fi
  brew install xcodegen
fi

xcodegen generate
open Forkcast.xcodeproj
