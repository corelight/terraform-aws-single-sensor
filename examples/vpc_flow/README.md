# VPC Flow Log Sensor (Private Preview)


### Copy the example tfvars file and populate it with your details
```shell
  cp examples/vpc_flow/example.tfvars foo.tfvars 
```

### Plan the deployment
```shell
    terraform plan --var-file foo.tfvars -out=tfplan
```

### Deploy the Plan
If the plan looks good go ahead and deploy it
```shell
    terraform apply tfplan
```
