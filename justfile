#!/usr/bin/env just --justfile

# List all available terraform modules
list:
    @find . -name "*.tf" -type f | xargs dirname | sort -u | sed 's|^\./||'

fmt:
    @terraform fmt -recursive .

init MODULE:
    cd {{ MODULE }} && terraform init

plan MODULE:
    cd {{ MODULE }} && terraform plan -out=planfile

apply-plan MODULE:
    cd {{ MODULE }} && terraform apply planfile

apply-auto MODULE:
    cd {{ MODULE }} && terraform apply -auto-approve

apply MODULE:
    cd {{ MODULE }} && terraform apply

destroy MODULE:
    cd {{ MODULE }} && terraform destroy

# ---- Deploy Specific ---- #
# NFS Driver
nfs-driver-up:
    just apply core/nfs-csi-driver/terraform

nfs-driver-down:
    just destroy core/nfs-csi-driver/terraform
