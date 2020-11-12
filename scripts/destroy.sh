#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
#set -x

BASEDIR=$(dirname $0)
ABSOLUTE_BASEDIR="$( cd ${BASEDIR} && pwd )"

source ${ABSOLUTE_BASEDIR}/utils.sh

confirm "Removing gitops playground from kubernetes cluster: '$(kubectl config current-context)'." 'Continue? y/n [n]' \
 || exit 0
 
# Don't fail when resources were not there 

# The following line is needed because the cr "fluxv2-kustomizer" has a finalizer set which can lead to a deadlock while deleting
# https://stackoverflow.com/a/52012367
kubectl patch kustomization fluxv2-kustomizer -p '{"metadata":{"finalizers":[]}}' --type=merge -n fluxv2 || true
kubectl delete -f fluxv2/k8s-resources/gotk-kustomization.yaml || true
kubectl delete -f fluxv2/k8s-resources/gotk-gitrepository.yaml || true
kubectl delete -f fluxv2/k8s-resources/gotk-components.yaml || true

helm delete scmm -n default || true
helm delete jenkins -n default || true
helm delete flux-operator -n default || true
helm delete helm-operator -n default || true
helm delete docker-registry -n default || true

kubectl delete -f jenkins/resources || true
kubectl delete -f scm-manager/resources || true

kubectl delete -f k8s-namespaces/ || true

#cleanup
kubectl delete crd/helmreleases.helm.fluxcd.io