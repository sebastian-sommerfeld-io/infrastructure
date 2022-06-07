#!/bin/bash
# @file tf.sh
# @brief Select a configuration and trigger terraform commands.
#
# @description The script triggers terraform commands for a set of configurations. Terraform itself is started from in a
# docker container, so there is no need to install Terraform on your machine.
#
# NOTE: This script controls the configurations for ``cloud`` and ``homelab``.
#
# The script supports the following options (after selecting the configuration for which terraform runs the commands):
#
# . ``init`` -> Initialize providers etc.
# . ``validate`` -> Run ``terraform validate && terraform fmt -recursive``
# . ``plan`` -> Run ``terraform plan`` (runs ``validate`` first)
# . ``apply`` -> Run ``terraform apply -auto-approve -var=do_token=<THE_DIGITAL_OCEAN_TOKEN>`` and ``terraform graph`` (runs ``validate`` first)
# . ``destroy`` -> Run ``terraform destroy -auto-approve -var=do_token=<THE_DIGITAL_OCEAN_TOKEN>`` and clean up some files (runs ``validate`` first)
#
# Steps, that change the infrastructure (plan, apply) also auto-generate some documentation and component graphs. These
# docs are added to the corresponding Antora module.
#
# ==== Arguments
#
# The script does not accept any parameters.
#
# ===== See also
#
# * https://hub.docker.com/r/hashicorp/terraform
# * https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image
# * https://learn.hashicorp.com/tutorials/terraform/docker-build?in=terraform/docker-get-started


NOT_SET="n/a"
TARGET_ENV="$NOT_SET"
TF_CONFIG_PATH="$NOT_SET"

DO_TOKEN=$(cat "../../resources/.secrets/digitalocean.token")
LINODE_TOKEN=$(cat "../../resources/.secrets/linode.token")

LABEL_HOMELAB="homelab"
LABEL_SOMMERFELD_IO="sommerfeld-io"

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
# @exitcode 5 If the path to the terraform configuration files is not set
# @exitcode 8 If param with terraform command is missing
function tf() {
  if [ "$TARGET_ENV" == "$NOT_SET" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] Stage not set"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 4
  fi
  if [ "$TF_CONFIG_PATH" == "$NOT_SET" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] Path to *.tf files not set"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 5
  fi
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] No command passed to the terraform container"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 8
  fi

  (
    cd "$TF_CONFIG_PATH" || exit

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
  tf plan -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
  generateDocs
}


# @description Apply this configuration by running ``terraform apply``.
#
# @example
#    echo "test: $(apply)"
function apply() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Apply this configuration"

  validate
  tf apply -auto-approve -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
  generateDocs
}


# @description Destroy this configuration by running ``terraform destroy``.
#
# @example
#    echo "test: $(destroy)"
function destroy() {
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Shutdown this configuration"

  validate
  tf destroy -auto-approve -var="do_token=$DO_TOKEN" -var="linode_token=$LINODE_TOKEN"
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
    cd "$TF_CONFIG_PATH" || exit

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

  BASE_FILENAME="terraform-$TARGET_ENV"
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
    pegasus/tf-graph-beautifier:latest terraform-graph-beautifier --exclude="module.root.provider" --output-type=graphviz)

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Prepare target dir and antora images dir"
  mkdir -p ../../target
  mkdir -p "../../$ANTORA_IMAGES_DIR"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate diagram image"
  echo "$pretty" | docker run -i --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    nshine/dot:latest > "../../target/$DIAGRAM_FILENAME"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Generate text documentation for this configuration"
  # append $TF_CONFIG_PATH because this command is not delegated to the `tf` function (which handles this for terraform commands)
  docker run -it --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    -u "$(id -u)" \
    quay.io/terraform-docs/terraform-docs:latest asciidoc "$(pwd)/$TF_CONFIG_PATH" > "../../target/$ADOC_FILENAME_TMP"

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Move diagram and asciidoc to antora module and add to git repo"
  (
    cd ../../ || exit
    mv "target/$DIAGRAM_FILENAME" "$ANTORA_IMAGES_DIR/$DIAGRAM_FILENAME"
    git add "$ANTORA_IMAGES_DIR/$DIAGRAM_FILENAME"

    tr -d '\015' < "target/$ADOC_FILENAME_TMP" > "target/$ADOC_FILENAME" # CRLF to LF
    mv "target/$ADOC_FILENAME" "$ANTORA_PARTIALS_DIR/$ADOC_FILENAME"
    git add "$ANTORA_PARTIALS_DIR/$ADOC_FILENAME"
  )
}


echo -e "$LOG_INFO Select the terraform configuration"
select s in "$LABEL_HOMELAB" "$LABEL_SOMMERFELD_IO"; do
  TARGET_ENV="$s"

  case "$TARGET_ENV" in
    "$LABEL_HOMELAB" ) TF_CONFIG_PATH="homelab/configuration";;
    "$LABEL_SOMMERFELD_IO" ) TF_CONFIG_PATH="cloud/sommerfeld-io/configuration";;
  esac

  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Selected as the configuration for which terraform will run its commands"
  echo -e "$LOG_INFO [$P$TARGET_ENV$D] Set path to *.tf files to $Y$TF_CONFIG_PATH$D"
  break
done


echo -e "$LOG_INFO Select the command set to run against $P$TARGET_ENV$D configuration"
select s in "$CMD_INIT" "$CMD_VALIDATE" "$CMD_PLAN" "$CMD_APPLY" "$CMD_DESTROY" "$CMD_CLEAN" "$CMD_DOCS"; do
  case "$s" in
    "$CMD_INIT" ) initialize; break;;
    "$CMD_VALIDATE" ) validate; break;;
    "$CMD_PLAN" ) plan; break;;
    "$CMD_APPLY" ) apply; break;;
    "$CMD_DESTROY" ) destroy; break;;
    "$CMD_CLEAN" ) clean; break;;
    "$CMD_DOCS" ) generateDocs; break;;
  esac
done
