#!/bin/bash
set -e

IFS=$'\n\t'

export AZURE_MOUNT_POINT=/home/$NB_USER/wasb

# Mount blobstore
test ${AZURE_MOUNT_POINT}
rm -rf ${AZURE_MOUNT_POINT}
mkdir -p ${AZURE_MOUNT_POINT}

if [[ ! -z "${AZURE_STORAGE_ACCOUNT}" && ! -z "${AZURE_STORAGE_ACCOUNT_CONTAINER}" ]] && [[ ! -z "${AZURE_STORAGE_ACCESS_KEY}" || ! -z "${AZURE_STORAGE_SAS_TOKEN}" ]]; then
  blobfuse ${AZURE_MOUNT_POINT} --use-https=true --tmp-path=/tmp/blobfuse/${AZURE_STORAGE_ACCOUNT} --container-name=${AZURE_STORAGE_ACCOUNT_CONTAINER} -o allow_other
fi
