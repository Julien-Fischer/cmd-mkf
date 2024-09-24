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


########################################################################
# Input parameters
########################################################################

quiet=-1

if [[ $# -gt 0 && "$1" = '-q' ]]; then
    quiet=1
fi

########################################################################
# Prepare installation
########################################################################

set -Eeuo pipefail

INITIAL_DIR=$(dirname "$(realpath "$0")")
source "${INITIAL_DIR}/mkf-functions.sh"

# Make the install script idempotent by removing older versions of mkf
if [[ -e 'mkf-uninstall.sh' ]]; then
    ./mkf-uninstall.sh -q -y
fi

########################################################################
# Constants
########################################################################

INSTALL_SCRIPT_DIR=$(dirname "$(realpath "$0")")
SOURCE_TEMPLATE_DIR="$(dirname "$INSTALL_SCRIPT_DIR")/templates"

########################################################################
# Installation process
########################################################################

if [[ $quiet -ne 1 ]]; then
    echo "This will install mkf."
    confirm "Installation" "Are you sure you want to proceed?" --abort
fi
echo "Installing..."

# Create $INSTALL_DIR if not exists
if [[ ! -d "${INSTALL_DIR}" ]]; then
    sudo mkdir -p "${INSTALL_DIR}"
    echo "Created installation directory at ${INSTALL_DIR}"
fi

# Install the command executable
echo "  Installing ${SCRIPT_NAME} to ${INSTALL_DIR}"
sudo cp "${INSTALL_SCRIPT_DIR}/${SCRIPT_NAME}" "${INSTALL_DIR}"
sudo cp "${INSTALL_SCRIPT_DIR}/${LIB_NAME}" "${INSTALL_DIR}"
sudo cp "${INSTALL_SCRIPT_DIR}/${UNINSTALL_NAME}" "${INSTALL_DIR}"
sudo chmod +x "${EXECUTABLE_PATH}"
echo "  Command executable installed."

echo "  Installing templates..."
# Remember native templates
write_files "${SOURCE_TEMPLATE_DIR}" "${NATIVE_TEMPLATES_NAME}"
sudo mv "${NATIVE_TEMPLATES_NAME}" "${INSTALL_DIR}"

# Create the template directory if not exists
if [[ ! -d "${TARGET_TEMPLATE_DIR}" ]]; then
    sudo mkdir -p "${TARGET_TEMPLATE_DIR}"
    echo "    Created template directory at ${TARGET_TEMPLATE_DIR}"
fi

# Install the template files
echo "    Copying preset templates to ${TARGET_TEMPLATE_DIR}"
sudo cp "${SOURCE_TEMPLATE_DIR}"/* "${TARGET_TEMPLATE_DIR}"

# Exit the installer
list_templates "${SOURCE_TEMPLATE_DIR}" "  Installed"
echo "${SCRIPT_NAME} successfully installed."
