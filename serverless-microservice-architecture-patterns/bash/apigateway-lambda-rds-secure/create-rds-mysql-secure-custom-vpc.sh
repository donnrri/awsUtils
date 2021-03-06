#!/bin/sh
# Copyright (c) 2017-2018 Starwolf Ltd and Richard Freeman. All Rights Reserved.
# Licensed under the Apache License, Version 2.0

# This script creates a MySQL RDS instance
# It is recommended that you change the username and password

. ./common-variables.sh

db_subnet_group_name=wolf-db-subnet

aws rds create-db-instance \
    --db-instance-identifier mysql-wolf-vpc \
    --db-instance-class db.t2.small \
    --engine mysql \
    --allocated-storage 5 \
    --publicly-accessible \
    --db-name dev \
    --master-username $user \
    --master-user-password $pass \
    --backup-retention-period 0 \
	--db-subnet-group-name $db_subnet_group_name \
	--no-multi-az \
	--enable-iam-database-authentication \
    --storage-encrypted \
    --profile $profile \
    --region $region || true