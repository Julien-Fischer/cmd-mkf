#!/usr/bin/env bash

# Copyright 2024 Julien Fischer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -Eeuo pipefail


########################################################################
# Uninstall process
########################################################################

# Provide a default value if INSTALL_DIR is unbound via parameter expansion
INSTALL_DIR="${INSTALL_DIR:-}"

# Attempt to source the file from INSTALL_DIR; otherwise use INITIAL_DIR
if [[ -z "$INSTALL_DIR" || ! -f "${INSTALL_DIR}/mkf-functions.sh" ]]; then
    INITIAL_DIR=$(dirname "$(realpath "$0")")
    source "${INITIAL_DIR}/mkf-functions.sh" || {
        echo "Failed to source mkf-functions.sh from INITIAL_DIR"
        exit 1
    }
else
    source "${INSTALL_DIR}/mkf-functions.sh" || {
        echo "Failed to source mkf-functions.sh from INSTALL_DIR"
        exit 1
    }
fi

quiet=0
if [[ $# -gt 0 && "$1" = '-q' ]]; then
    quiet=1
fi

########################################################################
# Uninstall process
########################################################################

if [[ $quiet -eq 0 ]]; then
    echo "This will uninstall mkf."
    confirm "Uninstallation" "Are you sure you want to proceed?"
    echo "Uninstalling..."
fi

# Remove templates from $TARGET_TEMPLATE_DIR if exists
if [[ -d "${TARGET_TEMPLATE_DIR}" ]]; then
    [[ $quiet -eq 0 ]] && list_templates "${TARGET_TEMPLATE_DIR}" "  Removing"
    sudo rm -r "${ROOT_TEMPLATE_DIR}"
fi

# Remove command from $INSTALL_DIR if exists
[[ $quiet -eq 0 ]] && echo "  Removing command files..."
if [[ -d "${INSTALL_DIR}" ]]; then
    if [[ -e "${UNINSTALL_PATH}" ]]; then
        sudo rm "${UNINSTALL_PATH}"
        [[ $quiet -eq 0 ]] && echo "    Removed ${UNINSTALL_NAME} from ${INSTALL_DIR}"
    fi
    if [[ -e "${EXECUTABLE_PATH}" ]]; then
        sudo rm "${EXECUTABLE_PATH}"
        [[ $quiet -eq 0 ]] && echo "    Removed ${SCRIPT_NAME} from ${INSTALL_DIR}"
    fi
    if [[ -e "${LIB_PATH}" ]]; then
        sudo rm "${LIB_PATH}"
        [[ $quiet -eq 0 ]] && echo "    Removed ${LIB_NAME} from ${INSTALL_DIR}"
    fi
fi

# Exit the uninstall script
if [[ $quiet -eq 0 ]]; then
    echo "${SCRIPT_NAME} successfully uninstalled."
fi