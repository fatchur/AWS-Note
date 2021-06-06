

## Create ECS Cluster
```
- select `create cluster`
- select `ec2 linux + networking`
- fill the cluster name 
```

```
# Instance Configuration
- for `provisioning model` --> choose `on demand`
- select the EC2 instance type
- select the keypair to SSH to your ec2 instance 
  (just follow the link about creating the keypair)
```

```
# Networking 
- VPC --> choose vpc-xxxx (default)
- subnet --> choose the first one 
- IMPORTANT, auto assign public IP --> enabled
- security group --> default 
```


## Apply Service to the Container (Task Definition)
```
- choose `task definition` on the lest section,
- `create new task definition`
- choose launch type -->`ec2`
```

```
# Task configuration 
- fill the task name 
- choose task role (optional)--> can be none if first time, better select the role
===>> this role used for your task to make API request to another AWS services
===>> AmazonECSTaskExecutionRolePolicy, cloudwatch, ec2, ecr

- network mode -> default (default docker networking)
- IAM execution role --> select same as task role
===>> this role required for task to pull the image from ECR, and push the log to cloudwatch
===>> AmazonECSTaskExecutionRolePolicy, cloudwatch, ec2, ecr
```

```
# Task size
- fill task memory
- fill task vcpu
```

```
# container definition
- click `add container` 
- fill container name
- fill container url (ensure lasting with version)
- set port mapping (between docker and host)
- click `add`
```


## Run the Tasks 
```
- go back to your created cluster
- at bottom, select `Tasks`
- select `run new task`
- for launch type --> ec2 (as we created before)
- set the number of task to be launched (basically how manu pods launched for this task in kubernetes)
- click `run task`
```

### Go back to your cluster task,
### Wait until `last update` status to be running 

```
- go to your EC2 instance which serving your task,
- get the public DNS (API) -->> ec2-xx-xx-xxx-
```

```
- got to your ec2 security group
- choose security group used for your cluster
- click `edit-inbliud-rule`
- click `add rule`

# for cluster (left side)
- choose `custom-tcp`, set port to the cluster port mapped to the docker port

# for the traffict source 
- select `anywhere`

- save rule
```