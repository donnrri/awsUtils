#!/bin/sh
# Copyright (c) 2017-2018 Starwolf Ltd and Richard Freeman. All Rights Reserved.
# Licensed under the Apache License, Version 2.0

#This Script creates a Lambda role and attaches the policy

#import variables
. ./common-variables.sh

#Setup Lambda Role
role_name=lambda-dynamo-data-api
aws iam create-role --role-name ${role_name} \
	--assume-role-policy-document file://../../IAM/assume-role-lambda.json \
	--profile $profile \
	--region $region || true

sleep 1
#Add and Attach Policy to Lambda Role
dynamo_policy=dynamo-readonly-user-visits
aws iam create-policy --policy-name $dynamo_policy --policy-document file://../../IAM/$dynamo_policy.json --profile $profile || true

role_policy_arn="arn:aws:iam::$aws_account_id:policy/$dynamo_policy"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  --profile ${profile} || true

#Add and Attach CloudWatch Policy to Lambda Role
cloudwatch_policy=lambda-cloud-write
aws iam create-policy --policy-name $cloudwatch_policy --policy-document file://../../IAM/$cloudwatch_policy.json --profile $profile || true

role_policy_arn="arn:aws:iam::$aws_account_id:policy/$cloudwatch_policy"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  --profile ${profile} || true
	
#Add Policy for X-Ray
role_policy_arn="arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  \
	--profile ${profile} || true
