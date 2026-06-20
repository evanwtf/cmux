#!/usr/bin/env bash
#
# Build the cmux macOS app with a single command and no flags.
#
#   ./scripts/build-macos.sh
#
# Runs first-time setup (submodules, GhosttyKit, git hooks) and then builds an
# isolated Debug app. Safe to re-run any time to rebuild — subsequent runs are
# incremental. When the build finishes it prints an `App path:` line you can
# cmd-click to open the app.
#
# The build is tagged (default tag: `local`) so it gets its own app name,
# bundle id, socket, and derived-data path and never collides with another
# cmux instance. Override the tag with the CMUX_TAG environment variable if you
# want a second isolated build, e.g. `CMUX_TAG=experiment ./scripts/build-macos.sh`.
#
# Contributors and AI agents doing iterative work should call
# `./scripts/reload.sh --tag <tag>` directly (one tag per branch/agent) — this
# wrapper is the zero-config "just build it" entry point.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# One-time setup (idempotent): initialize submodules, build/cache
# GhosttyKit.xcframework, and install the pbxproj pre-commit hook. Re-running is
# cheap — initialized submodules and a warm GhosttyKit cache are no-ops.
"$SCRIPT_DIR/setup.sh"

# Build the Debug app under a stable tag. reload.sh handles the macOS 26+ zig
# auto-skip and prints the App path on success.
exec "$SCRIPT_DIR/reload.sh" --tag "${CMUX_TAG:-local}"
