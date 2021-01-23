## Note
1. **Simple Configure**
```
After aws CLI installation, run:
- run aws configure
- set your username, key, region and password
- test your aws CLI, ex: aws s3 ls
```

2. **Profile Based Configure**

In case you are grouped basen on a job division by the AWS admin. They give you a profile, ex: `data-profile` for data science team.

- After doing simple configuration, check `~/.aws/config` file
```
nano ~/.aws/config
```
- You will see 
```
[default]
region=...
output=...
```
- Open the `~/.aws/credentials` file
```
nano ~/.aws/credentials
```
- you will see
```
[default]
aws_access_key_id=...
aws_secret_access_key=...
```
- COPY the file in `~/.aws/credentials` to `~/.aws/config`
```
[default]
region=...
output=...
aws_access_key_id=...
aws_secret_access_key=...
```
- Now ADD ADDITIONAL info, ASk your devops for that.
```
[default]
region=...
output=...
aws_access_key_id=...
aws_secret_access_key=...

[profile your-profile-name]
role_arn = arn:aws:iam::your-id:role/role-name
source_profile = defaullt
```
- Save and check 
```
aws s3 ls --profile your-profile-name
```




