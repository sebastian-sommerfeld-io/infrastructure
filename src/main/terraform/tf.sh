#!/bin/bash
# @file tf.sh
# @brief Select a configuration and trigger Terraform commands.
#
# @description The script triggers terraform commands for a set of configurations. Terraform itself is
# started inside a docker container, so there is no need to install Terraform on your machine.
#
# This script controls the configurations for:
#
# . ``configs/sommerfeld-io``
#
# These options also are the possible values for arg1.
#
# The script supports the following options (after selecting the configuration for which Terraform runs
# the commands):
#
# . ``init`` -> Initialize providers etc.
# . ``validate`` -> Run ``terraform validate && terraform fmt -recursive``
# . ``plan`` -> Run ``terraform plan`` (runs ``validate`` first)
# . ``apply`` -> Run ``terraform apply -auto-approve -var=do_token=<THE_DIGITAL_OCEAN_TOKEN>`` and ``terraform graph`` (runs ``validate`` first)
# . ``destroy`` -> Run ``terraform destroy -auto-approve -var=do_token=<THE_DIGITAL_OCEAN_TOKEN>`` and clean up some files (runs ``validate`` first)
#
# These options also are the possible values for arg2.
#
# Steps, that change the infrastructure (plan, apply) also auto-generate some documentation and component
# graphs. These docs are added to the corresponding Antora module.
#
# The script also supports arguments. The arguments are the same as the select menu options. When started
# with arguments, the select menus are skipped and the terraform commands are triggered directly. Running
# with arguments allows calling this script from other bash scripts without human interaction.
#
# ==== Arguments
#
# . *$1* (string): Target environment (optional)
# . *$2* (string): Terraform command (optional - becomes mandatory, when arg1 is present as well)
#
# ===== See also
#
# . https://hub.docker.com/r/hashicorp/terraform
# . https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image
# . https://learn.hashicorp.com/tutorials/terraform/docker-build?in=terraform/docker-get-started


NOT_SET="n/a"
TARGET_ENV="$NOT_SET"
COMMAND="$NOT_SET"

DO_TOKEN=$(cat "../../../resources/.secrets/digitalocean.token")
LINODE_TOKEN=$(cat "../../../resources/.secrets/linode.token")

CMD_INIT="initialize"
CMD_VALIDATE="validate"
CMD_PLAN="plan"
CMD_APPLY="apply"
CMD_DESTROY="destroy"
CMD_CLEAN="clean"
CMD_DOCS="generate_docs"


# @description Wrapper function to encapsulate terraform in a docker container. The current working directory is mounted
# into the container and selected as working directory so that all file are available to terraform. Paths are preserved.
#
# @example
#    echo "test: $(tf -version)"
#
# @arg $@ String The terraform commands (1-n arguments) - $1 is mandatory
#
# @exitcode 4 If the target environment (= terraform configuration) is not set
# @exitcode 8 If param with terraform command is missing
function tf() {
  if [ "$TARGET_ENV" == "$NOT_SET" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] Stage (= path to *.tf files) not set"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 4
  fi
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] No command passed to the terraform container"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 8
  fi

  (
    cd "$TARGET_ENV" || exit

    docker run -it --rm \
      --volume /var/run/docker.sock:/var/run/docker.sock \
      --volume /etc/timezone:/etc/timezone:ro \
      --volume /etc/localtime:/etc/localtime:ro \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      hashicorp/terraform:latest "$@"
  )
}


# @description Initialize this configuration by running ``terraform init``.
#
# @example
#    echo "test: $(initialize)"
function initialize() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Initialize this configuration"
  tf init
  generateDocs
}


# @description Validate this configuration by running ``terraform validate`` and apply consistent format to all .tf
# files by running ``terraform fmt -recursive``.
#
# @example
#    echo "test: $(validate)"
function validate() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Validate this configuration and apply consistent format to all .tf files"
  tf validate && tf fmt -recursive
}


# @description Plan this configuration by running ``terraform plan``.
#
# @example
#    echo "test: $(plan)"
function plan() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Plan this configuration"

  validate

  if [ "$TARGET_ENV" == "configs/sommerfeld-io" ]; then
    tf plan -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
  else
    tf plan
  fi

  generateDocs
}


# @description Apply this configuration by running ``terraform apply``.
#
# @example
#    echo "test: $(apply)"
function apply() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Apply this configuration"

  validate

  if [ "$TARGET_ENV" == "configs/sommerfeld-io" ]; then
    tf apply -auto-approve -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
  else
    tf apply
  fi

  generateDocs
}


# @description Destroy this configuration by running ``terraform destroy``.
#
# @example
#    echo "test: $(destroy)"
function destroy() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Shutdown this configuration"

  validate

  if [ "$TARGET_ENV" == "configs/sommerfeld-io" ]; then
    tf destroy -auto-approve -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
  else
    tf destroy
  fi
}

# @description Cleanup local filesystem.
#
# CAUTION: Only clean up after destroying the infrastructure!
#
# @example
#    echo "test: $(clean)"
function clean() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Cleanup local file system"

  (
    cd "$TARGET_ENV" || exit

    echo -e "$LOG_INFO [$P$TARGET_ENV$D] Cleanup local filesystem"
    rm -rf .terraform*
    rm -rf -- *.tfstate*
  )
}


# @description Generate diagram by running ``terraform graph`` and add this diagram to the documentation. Also generate
# docs by running the ``terraform-docs`` Docker image and add the generated asciidoc to the documentation.
#
# @example
#    echo "test: $(generateDocs)"
function generateDocs() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate graph for this configuration"

  search="/" # escape "/"
  replace="-"
  BASE_FILENAME="terraform-$(echo $TARGET_ENV | sed -e "s|$search|$replace|g")"

  DIAGRAM_FILENAME="$BASE_FILENAME.png"
  ADOC_FILENAME="$BASE_FILENAME.adoc"
  ADOC_FILENAME_TMP="$BASE_FILENAME-with-CRLF.adoc"
  ANTORA_IMAGES_DIR="docs/modules/ROOT/assets/images/generated/terraform"
  ANTORA_PARTIALS_DIR="docs/modules/ROOT/partials/generated/terraform"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate diagram specs and prettify diagram"
  diagram=$(tf graph)
  pretty=$(echo "$diagram" | docker run -i --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    sommerfeldio/tf-graph-beautifier:latest terraform-graph-beautifier --exclude="module.root.provider" --output-type=graphviz)

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Prepare target dir and antora images dir"
  mkdir -p ../../../target
  mkdir -p "../../../$ANTORA_IMAGES_DIR"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate diagram image"
  echo "$pretty" | docker run -i --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    nshine/dot:latest > "../../../target/$DIAGRAM_FILENAME"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate text documentation for this configuration"
  docker run -it --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    -u "$(id -u)" \
    quay.io/terraform-docs/terraform-docs:latest asciidoc "$(pwd)/$TARGET_ENV" > "../../../target/$ADOC_FILENAME_TMP"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Move diagram and asciidoc to antora module and add to git repo"
  (
    cd ../../../ || exit
    mv "target/$DIAGRAM_FILENAME" "$ANTORA_IMAGES_DIR/$DIAGRAM_FILENAME"
    git add "$ANTORA_IMAGES_DIR/$DIAGRAM_FILENAME"

    tr -d '\015' < "target/$ADOC_FILENAME_TMP" > "target/$ADOC_FILENAME" # CRLF to LF
    mv "target/$ADOC_FILENAME" "$ANTORA_PARTIALS_DIR/$ADOC_FILENAME"
    git add "$ANTORA_PARTIALS_DIR/$ADOC_FILENAME"
  )
}


# which terraform configuration (select or from param)
if [ -z "$1" ]
then
  echo -e "$LOG_INFO Select the terraform configuration"
  select d in configs/*/; do
    TARGET_ENV="${d::-1}"

    echo -e "$LOG_INFO [$P$TARGET_ENV$D] Selected as the configuration for which terraform will run its commands"
    echo -e "$LOG_INFO [$P$TARGET_ENV$D] Set path to *.tf files to $Y$TARGET_ENV$D"
    break
  done
else
  TARGET_ENV="$1"
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Script is called with arguments: target environment = $P$TARGET_ENV$D"
fi


# which terraform command (select or from param)
if [ -z "$2" ]
then
  echo -e "$LOG_INFO Select the command set to run against $P$TARGET_ENV$D configuration"
  select s in "$CMD_INIT" "$CMD_VALIDATE" "$CMD_PLAN" "$CMD_APPLY" "$CMD_DESTROY" "$CMD_CLEAN" "$CMD_DOCS"; do
    COMMAND="$s"
    break
  done
else
  COMMAND="$2"
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Script is called with arguments: terraform command = $P$COMMAND$D"
fi


# invoke terraform command
case "$COMMAND" in
  "$CMD_INIT" ) initialize;;
  "$CMD_VALIDATE" ) validate;;
  "$CMD_PLAN" ) plan;;
  "$CMD_APPLY" ) apply;;
  "$CMD_DESTROY" ) destroy;;
  "$CMD_CLEAN" ) clean;;
  "$CMD_DOCS" ) generateDocs;;
esac
