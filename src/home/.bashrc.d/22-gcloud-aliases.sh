#!/bin/bash
# =========================================================================================
# Arquivo: gcloud-aliases.sh
# Aliases para facilitar o uso do Google Cloud CLI
# =========================================================================================

alias gcp-projects='gcloud projects list'
alias gcp-config='gcloud config list'
alias gcp-auth='gcloud auth list'
alias gcp-compute='gcloud compute instances list'
alias gcp-storage='gcloud storage buckets list'
alias gcp-functions='gcloud functions list'
alias gcp-services='gcloud services list --enabled'
alias gcp-regions='gcloud compute regions list'
alias gcp-zones='gcloud compute zones list'
alias gcp-sql='gcloud sql instances list'
alias gcp-k8s='gcloud container clusters list'

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------