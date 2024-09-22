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
export TARGET_TEMPLATE_DIR="${ROOT_TEMPLATE_DIR}/templates"
export EXECUTABLE_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
export UNINSTALL_PATH="${INSTALL_DIR}/${UNINSTALL_NAME}"
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
    echo -n "$2 (y/n): "
    read answer
    case $answer in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            echo "$1 aborted."
            exit 1
            ;;
    esac
}