#!/bin/bash

echo "Getting instance id"
instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${INSTANCE_NAME}" --region ${AWS_DEFAULT_REGION} | jq -r '.Reservations[0].Instances[0].InstanceId')

echo "Instance id is: ${instance_id}"

# aws ssm binds to localhost in the container, have to use a proxy to publish 127.0.0.1:5432 -> 0.0.0.0:5555
socat tcp-listen:5555,reuseaddr,fork tcp:localhost:5432 &

aws ssm start-session \
    --region ${AWS_DEFAULT_REGION} \
    --target ${instance_id} \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters host="${RDS_HOST}",portNumber="5432",localPortNumber="5432"