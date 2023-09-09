# rds-tunnel

## TL;DR

Start tunnel
`make start-tunnel`

If you want to start it in the background
`make start-tunnel-bg`

And if you want to stop it after starting it:
`make stop-tunnel`

## Purpose

You can configure RDS in two ways:
1. It's publicly accessible
2. It's only accessible from within the VPC. You can also add additional safeguards, so it's only accessible from the EC2 instance which hosts the application (with security groups)

In case of the first option if you'd like to connect to the database with a outside of the VPC, you can just do that without issues. However, that's not really secure, because your database is open to the public internet.

The second option is much better from a security point of view, but it doesn't allow you to connect to RDS outside the VPC in case you'd like to check your data in the database.

Aurora Serverless V1 has a nice feature where you can use the AWS query editor to run queries directly from the AWS console. This is a nice feature, however it doesn't really replace your favorite Database Client (like DBeaver). It's also not available for Aurora Serverless V2 currently (verified on 2023.09.09).

The solution to this problem lies in this repository. It's using your application EC2 instance as a bastion instance, and it accesses it via AWS Systems Manager session manager. That way you don't need a dedicated bastion instance and you also don't need to open up anything to the internet.

The application EC2 instance that you'll define under `.env`, as `INSTANCE_NAME` will need the permissions to:
1. Access your RDS instance
2. Permissions for starting AWS Systems Manager session manager sessions