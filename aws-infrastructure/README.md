# AWS Infrastructure via Terraform for openIDL

The Terraform scripts in this folder are based on modules and [Terragrunt](https://terragrunt.io) based wrappers to allow the easy configuration per environment.
> **_NOTE:_**
> The following operations are executed in a 'local' type workspace in Terraform Cloud for ease of setting up credentials in the shell. The 'remote' executed type of workspace requires the credentials to be set via variables or variable set.
## Add Environment

To add a new environment copy one of the existing environments and change the name.
Make sure that the values in org-vars.yaml are updated as per the environment.

## Create Ops Infrastructure

### Create Terraform Cloud workspaces

> **_NOTE:_**
> This operation's state is kept locally only

The script creates three workspaces - one for the AWS resources, one for the Kubernetes resources and one for the operational applications such as Jenkins and AWX.
The names follow the patterns:
```
<project>-<org>-aws-resources
<project>-<org>-k8s-resources
<project>-<org>-ops
```

1. Set up the Terraform Cloud credentials 
   ```
   terraform login
   ```
   This step would open the TFC site where a new token could be created if you have not set it up before.
2. Copy and paste the token value in the terminal as requested
3. Create the workspaces
   ```
   cd environments/<env>/terraform-cloud
   terragrunt apply
   ```

### Configure the Ops workspace

Copy the values for the target AWS account by going to http://aws.senofi.ca

Configure the AWS system variables via IAM Identity for the account to be populated
   ```
   export AWS_ACCESS_KEY_ID="ASIA5ERN..."
   export AWS_SECRET_ACCESS_KEY="8QBK6GC7Q..."
   export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2..."
   export AWS_REGION="us-east-2"
   ```

### Create Terraform user and role

```
cd environments/<env>/iam
terragrunt plan
terragrunt apply
```

### Install Kubernetes Ops Cluster (Tools)

```
cd environments/<env>/k8s-cluster
terragrunt plan
terragrunt apply
```
