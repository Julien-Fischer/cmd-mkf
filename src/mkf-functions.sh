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
# Constants
########################################################################

export SCRIPT_NAME='mkf'
export LIB_NAME='mkf-functions.sh'
export UNINSTALL_NAME='mkf-uninstall.sh'
export INSTALL_DIR="/usr/local/bin"
export ROOT_TEMPLATE_DIR="/usr/local/share/${SCRIPT_NAME}"
export NATIVE_TEMPLATES_NAME='native_templates'
export TARGET_TEMPLATE_DIR="${ROOT_TEMPLATE_DIR}/templates"
export EXECUTABLE_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
export UNINSTALL_PATH="${INSTALL_DIR}/${UNINSTALL_NAME}"
export NATIVE_TEMPLATES_PATH="${INSTALL_DIR}/${NATIVE_TEMPLATES_NAME}"
export LIB_PATH="${INSTALL_DIR}/${LIB_NAME}"

########################################################################
# functions
########################################################################

function list_templates {
  local source_dir="${1}"
  local operation="${2}"
  cd "${source_dir}"
  template_array=(./*)
  template_count=${#template_array[@]}
  mapfile -t files < <(ls -1)
  echo "${operation} ${template_count} templates:"
  printf "    - %s\n" "${files[@]}"
}

function confirm() {
    local abort=0
    if [[ $# -ge 3 && "$3" == "--abort" ]]; then
        abort=1
    fi
    echo -n "$2 (y/n): "
    read answer
    case $answer in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            echo "$1 aborted."
            if [[ abort -eq 1 ]]; then
                exit 1
            fi
            return 1
            ;;
    esac
}

# Retrieves the names of the files in the specified directory
# arg $1  the path directory
# arg $2  the name of the array to use for storing the file names
function get_file_names {
    local directory="$1"
    local -n file_array="$2"  # nameref to the array passed as argument
    for file in "${directory}"/*; do
        if [[ -f "${file}" ]]; then
            filename=$(basename "${file}")
            file_array+=("${filename}")
        fi
    done
}

# Write the names of the files from a directory in the specified file.
# If the file does not exist, this function will create it
# arg $1  the path of the directory to scan
# arg $2  the name of the file to write to
function write_files {
    local directory="$1"
    local output_file="$2"
    if [[ ! -d "${directory}" ]]; then
        echo "${SCRIPT_NAME}: Invalid directory: ${directory}"
        return 1
    fi

    local -a files=()
    get_file_names "${directory}" files

    # clear the output file before writing
    > "${output_file}"

    for file in "${files[@]}"; do
        echo "${file}" >> "${output_file}"
    done
}
