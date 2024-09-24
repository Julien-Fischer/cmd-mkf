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


set -Euo pipefail


########################################################################
# Input parameters
########################################################################

quiet=-1
delete_custom_templates=0

if [[ $# -gt 0 && "$1" = '-q' ]]; then
    quiet=1
fi

if [[ $# -gt 0 && "$1" != '-q' && "$2" = '-y' ]]; then
    delete_custom_templates=1
fi

########################################################################
# Functions & lib
########################################################################

function delete_target {
    local path="${1}"
    local target="${2}"
    if [[ -e "${path}" ]]; then
        sudo rm "${path}"
        [[ $quiet -ne 1 ]] && echo "    - Removed ${target} from ${INSTALL_DIR}"
    fi
}

function source_lib {
    source "${INITIAL_DIR}/mkf-functions.sh" || {
        echo "Failed to source mkf-functions.sh from INITIAL_DIR"
        exit 1
    }
}

# Provide a default value if INSTALL_DIR is unbound via parameter expansion
INSTALL_DIR="${INSTALL_DIR:-}"

# Attempt to source the file from INSTALL_DIR; otherwise use INITIAL_DIR
if [[ -z "$INSTALL_DIR" || ! -f "${INSTALL_DIR}/mkf-functions.sh" ]]; then
    INITIAL_DIR=$(dirname "$(realpath "$0")")
    source_lib
fi

########################################################################
# Uninstall process
########################################################################

if [[ $quiet -ne 1 ]]; then
    echo "This will uninstall mkf."
    confirm "Uninstallation" "Are you sure you want to proceed?" --abort
    echo "Uninstalling..."
fi

# Remove templates from $TARGET_TEMPLATE_DIR if exists
if [[ -d "${TARGET_TEMPLATE_DIR}" ]]; then
    if [[ -e "${NATIVE_TEMPLATES_PATH}" ]]; then
        native_templates_count=$(grep -cve '^\s*$' "${NATIVE_TEMPLATES_PATH}")
        declare -a templates_names=()
        get_file_names "${TARGET_TEMPLATE_DIR}" templates_names
        templates_count=${#templates_names[@]}
        custom_templates_count=$((templates_count - native_templates_count))
        [[ $quiet -ne 1 ]] && echo "  Detected ${custom_templates_count} custom templates."
        [[ $quiet -ne 1 ]] && confirm "  Custom template deletion" "  Do you wish to keep your custom templates?"
        delete_custom_templates=$?
        [[ $quiet -ne 1 ]] && echo "  Keeping your custom templates."
        [[ $quiet -ne 1 ]] && echo "  Removing native templates..."
        if [[ $delete_custom_templates -eq 0 ]]; then
            while IFS= read -r filename; do
                [[ $quiet -ne 1 ]] && echo "    - Removed ${filename} from ${TARGET_TEMPLATE_DIR}"
                [[ $quiet -ne 1 ]] && sudo rm -f "/${TARGET_TEMPLATE_DIR}/${filename}"
            done < "${NATIVE_TEMPLATES_PATH}"
        fi
        sudo rm "${NATIVE_TEMPLATES_PATH}"
    fi
    if [[ $delete_custom_templates -eq 1 ]]; then
        [[ $quiet -ne 1 ]] && echo "  Removing custom templates..."
        [[ $quiet -ne 1 ]] && list_templates "${TARGET_TEMPLATE_DIR}" "  Detected"
        sudo rm -r "${ROOT_TEMPLATE_DIR}"
    fi
fi

# Remove command from $INSTALL_DIR if exists
[[ $quiet -ne 1 ]] && echo "  Removing command files..."
if [[ -d "${INSTALL_DIR}" ]]; then
    delete_target "${UNINSTALL_PATH}" "${UNINSTALL_NAME}"
    delete_target "${EXECUTABLE_PATH}" "${SCRIPT_NAME}"
    delete_target "${LIB_PATH}" "${LIB_NAME}"
fi

# Exit the uninstall script
if [[ $quiet -ne 1 ]]; then
    echo "${SCRIPT_NAME} successfully uninstalled."
fi