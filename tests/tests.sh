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


###############################################################
## Tests constants
###############################################################

APP_DIR=/app/runner
current_date=$(date +%Y-%m-%d)

###############################################################
## Fixtures
###############################################################

function test {
    # Before each
    cd $APP_DIR
    rm -rf ./*
    func_name="$1"
    # Execute test
    $func_name
    # After each
}

###############################################################
## Helpers
###############################################################

function find_date_file {
      local search_dir="$1"
      local file_name="${2:-''}"
      local matching_file=$(find "$search_dir" -type f -regex ".*${current_date}${file_name}")
      if [ -n "$matching_file" ]; then
          echo "$matching_file"
      else
          echo "No matching files found."
      fi
}

function find_datetime_file {
      local search_dir="$1"
      local matching_file=$(find "$search_dir" -type f -regex ".*${current_date}_[0-9][0-9]-[0-9][0-9]-[0-9][0-9].*")
      if [ -n "$matching_file" ]; then
          echo "$matching_file"
      else
          echo "No matching files found."
      fi
}

function command_exists {
    command -v "$1" >/dev/null 2>&1
}

###############################################################
## Define tests
###############################################################

function create_file_with_current_date_as_title_in_current_directory {
    mkf
    if [[ -z "${current_date}" ]]; then
        echo "Failed: create_file_with_current_date_as_title_in_current_directory"
        exit 1
    fi
}

function create_file_with_specified_extension {
    mkf -e log
    if [[ -z $(find_date_file . '.log') ]]; then
        echo "Failed: create_file_with_specified_extension"
        exit 1
    fi
}

function create_file_with_specified_name_and_extension {
    mkf hello -e log
    if [[ -z $(find_date_file . '.log') ]]; then
        echo "Failed: create_file_with_specified_name_and_extension"
        exit 1
    fi
}

function create_file_in_named_directory {
    # Given
    mkdir new_dir
    # When
    mkf -d new_dir
    # Then
    if [[ -z $(find_date_file new_dir) ]]; then
        echo "Failed: create_file_in_specified_directory"
        exit 1
    fi
}

function create_file_in_parent_directory {
    # Given
    mkdir -p a/b
    cd a/b
    # When
    mkf -d ..
    # Then
    if [[ -z $(find_date_file ..) ]]; then
        echo "Failed: create_file_in_parent_directory"
        exit 1
    fi
}

function create_file_in_grandparent_directory {
    # Given
    mkdir -p a/b/c
    cd a/b/c
    # When
    mkf -d ../..
    # Then
    if [[ -z $(find_date_file ../..) ]]; then
        echo "Failed: create_file_in_grandparent_directory"
        exit 1
    fi
}

function create_file_in_named_directory_long {
    # Given
    mkdir new_dir
    # When
    mkf --directory=new_dir
    # Then
    if [[ -z $(find_date_file new_dir) ]]; then
        echo "Failed: create_file_in_named_directory_long"
        exit 1
    fi
}

function create_file_in_parent_directory_long {
    # Given
    mkdir -p a/b/c
    cd a/b/c
    # When
    mkf --directory=..
    # Then
    if [[ -z $(find_date_file ..) ]]; then
        echo "Failed: create_file_in_parent_directory_long"
        exit 1
    fi
}

function create_file_in_grandparent_directory_long {
    # Given
    mkdir -p a/b/c
    cd a/b/c
    # When
    mkf --directory=../..
    # Then
    if [[ -z $(find_date_file ../..) ]]; then
        echo "Failed: create_file_in_grandparent_directory_long"
        exit 1
    fi
}

function create_timestamped_file {
    # When
    mkf -t
    # Then
    if [[ -z $(find_datetime_file .) ]]; then
        echo "Failed: create_timestamped_file"
        exit 1
    fi
}

function create_timestamped_file_long {
    # When
    mkf --time
    # Then
    if [[ -z $(find_datetime_file .) ]]; then
        echo "Failed: create_timestamped_file_long"
        exit 1
    fi
}

function create_file_with_template_includes_template {
    # When
    mkf -T meeting
    # Then
    if [[ $(cmp --silent "$(find_date_file .)" ../../templates/meeting) ]]; then
        echo "Failed: create_file_with_template_includes_template"
        exit 1
    fi
}

function create_file_with_template_includes_template_long {
    # When
    mkf --template=meeting
    # Then
    if [[ $(cmp --silent "$(find_date_file .)" ../../templates/meeting) ]]; then
        echo "Failed: create_file_with_template_includes_template_long"
        exit 1
    fi
}

function install_is_idempotent {
    # Given
    pattern='^mkf version ([0-9]+\.[0-9]+\.[0-9]+) \[(\d{4}-\d{2}-\d{2})\]$'
    # When
    ../cmd-mkf/src/install.sh -q
    ../cmd-mkf/src/install.sh -q
    # Then
    if [[ $(mkf -v) =~ $pattern} ]]; then
        echo "Failed: install_is_idempotent"
        exit 1
    fi
}

function uninstall_removes_mkf {
    # When
    ../cmd-mkf/src/mkf-uninstall.sh -q
    # Then
    if mkf > /dev/null 2>&1; then
        echo "Failed: uninstall_removes_mkf"
        exit 1
    fi
    # Reinstall mkf
    ../cmd-mkf/src/install.sh -q
}


###############################################################
## Execute tests
###############################################################

echo "[$(date '+%H:%M:%S')] Executing tests..."
mkf -v
echo "--------------------------------------"

# mkf
test create_file_with_current_date_as_title_in_current_directory

# mkf -e
test create_file_with_specified_extension
test create_file_with_specified_name_and_extension

# mkf -d
test create_file_in_named_directory
test create_file_in_parent_directory
test create_file_in_grandparent_directory
# mkf --directory
test create_file_in_named_directory_long
test create_file_in_parent_directory_long
test create_file_in_grandparent_directory_long

# mkf -t
test create_timestamped_file
# mkf --time
test create_timestamped_file_long

# mkf -T
test create_file_with_template_includes_template
# mkf --template
test create_file_with_template_includes_template_long

# ./install.sh
test install_is_idempotent

# ./mkf-uninstall.sh
test uninstall_removes_mkf
test uninstall_is_idempotent

echo "--------------------------------------"
echo "[$(date '+%H:%M:%S')] Tests passed."

# keep the container running indefinitely for debugging / interacting with it
# tail -f /dev/null
