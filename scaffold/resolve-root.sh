#!/usr/bin/env bash
# resolve-root.sh
# Source this file to get KNZINIT_ROOT and KNZINIT_VERSION exports.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/resolve-root.sh"
#
# After sourcing, the following are available:
#   KNZINIT_ROOT     — absolute path to the knzinit plugin root directory
#   KNZINIT_VERSION  — version string read from .claude-plugin/plugin.json
#   knzinit_version_marker — function that returns the HTML version comment

_knzinit_resolve_root() {
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
    "${HOME}/.claude/plugins/knzinit"
    "${CLAUDE_PROJECT_DIR:-}/.claude/plugins/knzinit"
  )
  for dir in "${known_dirs[@]}"; do
    if [[ -n "${dir}" && -d "${dir}" && -f "${dir}/.claude-plugin/plugin.json" ]]; then
      echo "${dir}"
      return 0
    fi
  done

  # 4. All resolution strategies exhausted
  echo "resolve-root.sh: ERROR: Cannot locate knzinit plugin root." >&2
  echo "  Set CLAUDE_PLUGIN_ROOT to the plugin directory, or ensure this" >&2
  echo "  script is located inside the plugin directory tree." >&2
  return 1
}

# Resolve and export KNZINIT_ROOT
KNZINIT_ROOT="$(_knzinit_resolve_root)"
if [[ $? -ne 0 ]]; then
  return 1 2>/dev/null || exit 1
fi
export KNZINIT_ROOT

# Read version from plugin.json (no jq dependency — use grep/sed)
_knzinit_read_version() {
  local plugin_json="${KNZINIT_ROOT}/.claude-plugin/plugin.json"
  if [[ ! -f "${plugin_json}" ]]; then
    echo "unknown"
    return 0
  fi
  # Extract "version": "X.Y.Z" — works with standard JSON formatting
  grep '"version"' "${plugin_json}" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/'
}

KNZINIT_VERSION="$(_knzinit_read_version)"
export KNZINIT_VERSION

# Helper function: returns the HTML version marker comment
knzinit_version_marker() {
  echo "<!-- knzinit v${KNZINIT_VERSION} -->"
}

# Clean up internal helpers from the shell namespace
unset -f _knzinit_resolve_root _knzinit_read_version
