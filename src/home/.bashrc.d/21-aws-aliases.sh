#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/aws-aliases.sh
# Aliases para facilitar o uso do AWS CLI v2
# ==========================================================================================

alias aws-profile='aws configure list-profiles'
alias aws-whoami='aws sts get-caller-identity'
alias aws-regions='aws ec2 describe-regions --query "Regions[].RegionName" --output table'
alias aws-s3-buckets='aws s3 ls'
alias aws-ec2-instances='aws ec2 describe-instances --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType,Name:Tags[?Key=='\''Name'\''].Value|[0]}" --output table'
alias aws-lambda-functions='aws lambda list-functions --query "Functions[].{Name:FunctionName,Runtime:Runtime,LastModified:LastModified}" --output table'
alias aws-rds-instances='aws rds describe-db-instances --query "DBInstances[].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Class:DBInstanceClass}" --output table'
alias aws-cloudformation-stacks='aws cloudformation describe-stacks --query "Stacks[].{Name:StackName,Status:StackStatus,Created:CreationTime}" --output table'

#-------------------------------------------------------------------------------------------
#--- Final do script 'aws-aliases.sh'
#-------------------------------------------------------------------------------------------