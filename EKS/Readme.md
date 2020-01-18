## Note
1. Install aws CLI and setup the aws configuration (`aws configure`)
2. Install kubectl for AWS: [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html#w243aac27b9b9b3)
3. Install aws-iam-authenticator: [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) 

### =>
4. create the kubernetes cluster via EKS UI
5. After the cluster created, create the [EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/worker_node_IAM_role.html) in AWS cloud formation (IF NEVER created yet)
6. Create the cluster node
7. Create a kubeconfig in local terminal for amazon EKS: [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

```
aws sts get-caller-identity
aws --version
aws eks --region <region> update-kubeconfig --name <cluster_name>
kubectl get svc
```

**Error list:**
- You must be logged in to the server (Unauthorized): you have to create the eks cluster with the same ID as used in AWS-CLI

8. Test: `kubectl get nodes`
### =>

9. Add other user to your created EKS: [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) 
10. Install eksctl: [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)  
11. 