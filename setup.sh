#!/usr/bin/env bash
# MuJoCo quickstart (macOS / Linux) - Praxtify (https://praxtify.com)
# One command: installs Python + VS Code (macOS, if missing), the VS Code Python extension,
# a virtual environment with MuJoCo, writes hello_mujoco.py and runs it.
#
#   curl -fsSL https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.sh | bash
#
# Optional environment variables:
#   MUJOCO_DIR=...    project folder            (default: ~/mujoco-quickstart)
#   MUJOCO_NO_RUN=1   do not start the simulation at the end
#   MUJOCO_NO_CODE=1  do not install/open VS Code or its Python extension
#
# MIT License - Copyright (c) 2026 Praxtify

set -u

REPO_RAW="https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main"
PY_PKG_VERSION="3.13.7"
DIR="${MUJOCO_DIR:-$HOME/mujoco-quickstart}"
OS="$(uname -s)"

step() { printf '\n\033[36m[%s/6] %s\033[0m\n' "$1" "$2"; }
ok()   { printf '      \033[32mOK\033[0m  %s\n' "$1"; }
info() { printf '      %s\n' "$1"; }
fail() { printf '\n  \033[31mERROR\033[0m  %s\n\n' "$1"; exit 1; }

# Prints the path of a working Python >= 3.10.
find_python() {
    for cmd in python3.13 python3.12 python3.11 python3.10 python3 python \
               /opt/homebrew/bin/python3 /usr/local/bin/python3 \
               /Library/Frameworks/Python.framework/Versions/3.13/bin/python3; do
        p="$(command -v "$cmd" 2>/dev/null)" || continue
        if "$p" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; then
            echo "$p"; return 0
        fi
    done
    return 1
}

find_code() {
    command -v code 2>/dev/null && return 0
    for p in "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
             "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
        [ -x "$p" ] && { echo "$p"; return 0; }
    done
    return 1
}

printf '\n  MuJoCo quickstart (%s)  -  praxtify.com\n  Project folder: %s\n' "$OS" "$DIR"

# 1 - Python
step 1 "Python"
PYTHON="$(find_python)"
if [ -z "$PYTHON" ]; then
    if [ "$OS" = "Darwin" ]; then
        if command -v brew >/dev/null 2>&1; then
            info "Python not found - installing python@3.13 with Homebrew..."
            brew install python@3.13 || fail "brew install python@3.13 failed."
        else
            info "Python not found - installing Python $PY_PKG_VERSION from python.org (asks for your password)..."
            PKG="/tmp/python-$PY_PKG_VERSION.pkg"
            curl -fL -o "$PKG" "https://www.python.org/ftp/python/$PY_PKG_VERSION/python-$PY_PKG_VERSION-macos11.pkg" \
                || fail "Download failed. Install Python from https://www.python.org/downloads/ and run this again."
            sudo installer -pkg "$PKG" -target / || fail "Python installer failed."
        fi
    else
        fail "Python 3.10+ not found. Install it (Ubuntu/Debian: sudo apt install python3 python3-venv) and run this again."
    fi
    PYTHON="$(find_python)" || fail "Python was installed but could not be found. Open a new terminal and run this again."
fi
ok "$("$PYTHON" --version 2>&1)"

# 2 - VS Code
step 2 "VS Code"
CODE=""
if [ "${MUJOCO_NO_CODE:-0}" != "1" ]; then
    CODE="$(find_code)"
    if [ -z "$CODE" ] && [ "$OS" = "Darwin" ]; then
        info "VS Code not found - installing..."
        if command -v brew >/dev/null 2>&1; then
            brew install --cask visual-studio-code
        else
            curl -fL -o /tmp/vscode.zip "https://update.code.visualstudio.com/latest/darwin-universal/stable" \
                && ditto -xk /tmp/vscode.zip /Applications
        fi
        CODE="$(find_code)"
    fi
    if [ -n "$CODE" ]; then ok "VS Code found"; else info "VS Code not found - skipping (install it from https://code.visualstudio.com)."; fi
else
    info "skipped (MUJOCO_NO_CODE=1)"
fi

# 3 - VS Code Python extension
step 3 "VS Code Python extension"
if [ -n "$CODE" ]; then
    "$CODE" --install-extension ms-python.python --force >/dev/null 2>&1
    ok "ms-python.python"
else
    info "skipped"
fi

# 4 - virtual environment + MuJoCo
step 4 "Virtual environment + MuJoCo"
mkdir -p "$DIR" || fail "Could not create $DIR"
VENV_PY="$DIR/.venv/bin/python"
if [ ! -x "$VENV_PY" ]; then
    "$PYTHON" -m venv "$DIR/.venv" || fail "Could not create the virtual environment (Ubuntu/Debian: sudo apt install python3-venv)."
fi
"$VENV_PY" -m pip install --upgrade --disable-pip-version-check --quiet mujoco \
    || fail "pip install mujoco failed. Check your internet connection and run this again."
ok "mujoco $("$VENV_PY" -c 'import mujoco; print(mujoco.__version__)')"

# 5 - project files
step 5 "Project files"
HELLO="$DIR/hello_mujoco.py"
if [ ! -f "$HELLO" ]; then
    LOCAL=""
    [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ] && LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hello_mujoco.py"
    if [ -n "$LOCAL" ] && [ -f "$LOCAL" ]; then cp "$LOCAL" "$HELLO"
    else curl -fsSL -o "$HELLO" "$REPO_RAW/hello_mujoco.py" || fail "Could not download hello_mujoco.py"; fi
fi
mkdir -p "$DIR/.vscode"
if [ ! -f "$DIR/.vscode/settings.json" ]; then
    cat > "$DIR/.vscode/settings.json" <<'JSON'
{
    "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
    "python.terminal.activateEnvironment": true
}
JSON
fi
ok "hello_mujoco.py  +  .vscode/settings.json"

# 6 - open in VS Code and run
step 6 "Run"
[ -n "$CODE" ] && "$CODE" "$DIR" "$HELLO"
if [ "${MUJOCO_NO_RUN:-0}" = "1" ]; then
    info "skipped (MUJOCO_NO_RUN=1)"
else
    info "Starting the simulation - close the MuJoCo window to finish."
    (cd "$DIR" && "$VENV_PY" hello_mujoco.py)
fi

printf '\n  \033[32mDone. Next time: open the folder in VS Code and press Run on hello_mujoco.py.\033[0m\n'
printf '  \033[32mMore robotics projects: https://github.com/praxtify  -  https://praxtify.com\033[0m\n'
