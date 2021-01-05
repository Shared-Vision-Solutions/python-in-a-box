#!/bin/bash

ROOT="$(git rev-parse --show-toplevel)"

install_git_hooks() {
  pushd "${ROOT}"  > /dev/null
    set +e
      cd .git/hooks
      ln -sf ../../scripts/hooks/pre-commit pre-commit
    set -e
  popd  > /dev/null
}

pib_setup_hostmachine() {
  poetry install
}

# shellcheck disable=SC2139
alias dev="PROJECT_NAME=\"{{cookiecutter.project_slug}}\" PIB_CONFIG_FILE_LOCATION=\"${ROOT}/assets/cli.yml\" poetry run dev"
