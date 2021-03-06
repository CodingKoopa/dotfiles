#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh

# Installs VSCode extensions from a hardcoded list.
# Outputs:
#   - VSCode installation progress
function install_vscode_extensions() {
  local -ra EXTENSIONS=(
    dbaeumer.vscode-eslint
    EditorConfig.EditorConfig
    foxundermoon.shell-format
    GitLab.gitlab-workflow
    mikestead.dotenv
    mrmlnc.vscode-csscomb
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    redhat.java
    redhat.vscode-yaml
    timonwong.shellcheck
    twxs.cmake
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    yzhang.markdown-all-in-one
  )
  local -r installed_extensions=$(code --list-extensions)
  for extension in "${EXTENSIONS[@]}"; do
    if [[ $installed_extensions != *$extension* ]]; then
      info "Installing extension $extension."
      code --install-extension "$extension"
    else
      verbose "Extension $extension is already installed."
    fi
  done
}
