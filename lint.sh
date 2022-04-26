#!/bin/bash
# @file lint.sh
# @brief Update und run linters.
#
# @description The script updates linter definitions from ``assets`` Repo and runs linters.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Download latest linter definitions"
linterDefinitions=(
  '.ls-lint.yml'
  '.yamllint'
  '.folderslintrc'
)
for file in "${linterDefinitions[@]}"; do
  rm "$file"
  curl -sL "https://raw.githubusercontent.com/sebastian-sommerfeld-io/infrastructure/main/resources/common-assets/linters/$file" -o "$file"
  git add "$file"
done

echo -e "$LOG_INFO ------------------------------------------------------------------------"
echo -e "$LOG_INFO Run linter containers"
docker run -it --rm --volume "$(pwd):/data" --workdir "/data" cytopia/yamllint:latest .
docker run -it --rm --volume "$(pwd):/data" --workdir "/data" koalaman/shellcheck:latest ./*.sh
# todo ... iterate folders (and print folder)
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/adoc-antora/Dockerfile
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/folderslint/Dockerfile
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/ftp-client/Dockerfile
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/git/Dockerfile
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/jq/Dockerfile
docker run -i  --rm hadolint/hadolint < src/main/workstations/kobol/vagrantboxes/pegasus/docker/images/yq/Dockerfile
docker run -it --rm --volume "$(pwd):/data" --workdir "/data" lslintorg/ls-lint:1.11.0
docker run -i  --rm --volume "$(pwd):$(pwd)" --workdir "$(pwd)" pegasus/folderslint:latest folderslint .
echo -e "$LOG_INFO ------------------------------------------------------------------------"
