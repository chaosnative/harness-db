#!/bin/bash
# This script is used to pull litmus images required to run generic experiments
# using litmus portal and push into your image registry
set -e

declare -a portal_images=("hce-frontend" "hce-server" "hce-event-tracker" "hce-auth-server" "hce-subscriber" "hce-license-module")

declare -a backend_images=("chaos-operator" "chaos-runner" "chaos-exporter" "go-runner")

declare -a workflow_images=("k8s:2.8.0" "litmus-checker:2.8.0" "workflow-controller:v3.2.3" "argoexec:v3.2.3" "mongo:4.2.8" "curl:2.8.0")

declare -a temp_images=("k8s:latest")

docker login --username=${DOCK_USER} --password=${DOCK_PASS}

if [[ -z "${LITMUS_BACKEND_TAG}" ]];then
  LITMUS_BACKEND_TAG="2.8.0"
fi

if [[ -z "${LITMUS_PORTAL_TAG}" ]];then
  LITMUS_PORTAL_TAG="2.8.0"
fi

if [[ -z "${LITMUS_IMAGE_REGISTRY}" ]];then
  LITMUS_IMAGE_REGISTRY="docker.io"
fi

if [[ -z "${TARGET_IMAGE_REGISTRY}" ]];then
  TARGET_IMAGE_REGISTRY="docker.io"
  TARGET_REPONAME="jonsy13"
fi

list_all(){

i=1
echo
echo "portal component images ..."
for val in ${portal_images[@]}; do
  echo "${i}. ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_PORTAL_TAG}"
  i=$((i+1))
done
echo

echo "backend component images ..."
for val in ${backend_images[@]}; do
  echo "${i}. ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_BACKEND_TAG}"
  i=$((i+1))
done
echo

echo "workflow controller images ..."
for val in ${workflow_images[@]}; do
  echo "${i}. ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}"
  i=$((i+1))echo "workflow controller images ..."
done
echo

echo "temporary images ..."
for val in ${temp_images[@]}; do
  echo "${i}. ${LITMUS_IMAGE_REGISTRY}/litmuschaos/${val}"
  i=$((i+1))
done
echo

}

pull_all(){

for val in ${portal_images[@]}; do
  echo " Pulling ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_PORTAL_TAG}"
  docker pull ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_PORTAL_TAG}
  echo
done
echo

for val in ${backend_images[@]}; do
  echo " Pulling ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_BACKEND_TAG}"
  docker pull ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}:${LITMUS_BACKEND_TAG}
  echo
done
echo

for val in ${workflow_images[@]}; do
  echo " Pulling ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}"
  docker pull ${LITMUS_IMAGE_REGISTRY}/chaosnative/${val}
  echo
done
echo

for val in ${temp_images[@]}; do
  echo " Pulling ${LITMUS_IMAGE_REGISTRY}/litmuschaos/${val}"
  docker pull ${LITMUS_IMAGE_REGISTRY}/litmuschaos/${val}
  echo
done
echo
}

tag_and_push_all(){

if [[ -z "${TARGET_REPONAME}" ]];then
  printf "Please provide the target repo-name by setting TARGET_REPONAME ENV. like:
  TARGET_REPONAME=\"chaosnative\"\n"
  exit 1
fi

echo
for val in ${portal_images[@]}; do
  IMAGEID=$( docker images -q chaosnative/${val}:${LITMUS_PORTAL_TAG} )
  docker tag ${IMAGEID} ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}:${LITMUS_PORTAL_TAG}
  docker push ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}:${LITMUS_PORTAL_TAG}
  echo
done

for val in ${backend_images[@]}; do
  IMAGEID=$( docker images -q chaosnative/${val}:${LITMUS_BACKEND_TAG} )
  docker tag ${IMAGEID} ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}:${LITMUS_BACKEND_TAG}
  docker push ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}:${LITMUS_BACKEND_TAG}
  echo
done
echo

for val in ${workflow_images[@]}; do
  IMAGEID=$( docker images -q chaosnative/${val} )
  docker tag ${IMAGEID} ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}
  docker push ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}
  echo
done
echo

for val in ${temp_images[@]}; do
  IMAGEID=$( docker images -q litmuschaos/${val} )
  docker tag ${IMAGEID} ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}
  docker push ${TARGET_IMAGE_REGISTRY}/${TARGET_REPONAME}/${val}
  echo
done
echo
}

print_help(){
cat <<EOF

Usage:       ${0} ARGS (list|pull|push)

list:        "${0} list" will list all the images used by the litmus portal.     


pull:        "${0} pull" will pull the litmus images with the given image tag. 
              The value of tag can be provided by exporting following ENVs:
              - LITMUS_PORTAL_TAG: Tag for the portal component like 'litmusportal-frontend' etc
              - LITMUS_BACKEND_TAG: Tag for backend component chaos-operator, chaos-runner, go-runner etc
              - LITMUS_IMAGE_REGISTRY: Name of litmuschaos image registry. Default is docker.io
              The default images tags are the latest tags released.

push:         "${0} push" will push the images to the given target image registry with the give repo-name
              The value of target images can be set by exporting following ENVs:
              - TARGET_IMAGE_REGISTRY: Give the target registry name. Default is set to "docker.io"
              - TARGET_REPONAME: Give the target image repo-name. This is mandatory to provide.               

EOF

}


case ${1} in
  list)
    list_all
    ;;
  pull)
    pull_all 
    ;;
  push)
    tag_and_push_all
    ;;
  *)
    print_help
    exit 1
esac
