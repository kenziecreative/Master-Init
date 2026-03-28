#!/usr/bin/env bash
# resolve-root.sh
# Source this file to get TRAILHEAD_ROOT and TRAILHEAD_VERSION exports.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/resolve-root.sh"
#
# After sourcing, the following are available:
#   TRAILHEAD_ROOT     — absolute path to the trailhead plugin root directory
#   TRAILHEAD_VERSION  — version string read from .claude-plugin/plugin.json
#   trailhead_version_marker — function that returns the HTML version comment

_trailhead_resolve_root() {
  local candidate

  # 1. Prefer CLAUDE_PLUGIN_ROOT if set and the directory exists
  if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" && -d "${CLAUDE_PLUGIN_ROOT}" ]]; then
    if [[ -f "${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json" ]]; then
      echo "${CLAUDE_PLUGIN_ROOT}"
      return 0
    fi
  fi

  # 2. Dynamic fallback: walk up from this script's own location
  #    looking for a directory that contains .claude-plugin/plugin.json
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  candidate="${script_dir}"
  while [[ "${candidate}" != "/" ]]; do
    if [[ -f "${candidate}/.claude-plugin/plugin.json" ]]; then
      echo "${candidate}"
      return 0
    fi
    candidate="$(dirname "${candidate}")"
  done

  # 3. Try known plugin install locations
  local known_dirs=(
    "${HOME}/.claude/plugins/trailhead"
    "${CLAUDE_PROJECT_DIR:-}/.claude/plugins/trailhead"
  )
  for dir in "${known_dirs[@]}"; do
    if [[ -n "${dir}" && -d "${dir}" && -f "${dir}/.claude-plugin/plugin.json" ]]; then
      echo "${dir}"
      return 0
    fi
  done

  # 4. All resolution strategies exhausted
  echo "resolve-root.sh: ERROR: Cannot locate trailhead plugin root." >&2
  echo "  Set CLAUDE_PLUGIN_ROOT to the plugin directory, or ensure this" >&2
  echo "  script is located inside the plugin directory tree." >&2
  return 1
}

# Resolve and export TRAILHEAD_ROOT
TRAILHEAD_ROOT="$(_trailhead_resolve_root)"
if [[ $? -ne 0 ]]; then
  return 1 2>/dev/null || exit 1
fi
export TRAILHEAD_ROOT

# Read version from plugin.json (no jq dependency — use grep/sed)
_trailhead_read_version() {
  local plugin_json="${TRAILHEAD_ROOT}/.claude-plugin/plugin.json"
  if [[ ! -f "${plugin_json}" ]]; then
    echo "unknown"
    return 0
  fi
  # Extract "version": "X.Y.Z" — works with standard JSON formatting
  grep '"version"' "${plugin_json}" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/'
}

TRAILHEAD_VERSION="$(_trailhead_read_version)"
export TRAILHEAD_VERSION

# Helper function: returns the HTML version marker comment
trailhead_version_marker() {
  echo "<!-- trailhead v${TRAILHEAD_VERSION} -->"
}

# Clean up internal helpers from the shell namespace
unset -f _trailhead_resolve_root _trailhead_read_version
