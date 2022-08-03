# SharedTerraform
A space for shared terraform modules

## Modules

* General Usage
  ```
  module "module_name" {
  source       = "github.com/TheBatchelorFamily/SharedTerraform.git//modules/module_name?ref=1.0.0"
  moduleVar1   = var.localVar1
  moduleVar2   = var.localVar2
  ModuleVar3   = var.localVar3
  ...
  }
  ```

### aws_auto_scale

* Overview
  
  * An ssh key pair is created
  * An iam role and policy is created to allow the EC2 instances created to grab the elastic ip
  * An instance profile is created to assign the iam role to EC2 instances created via the auto scaling group
  * A launch template is created to specify the types of instances that will be built
  * An autoscaling group is created to orchestrate the launching of EC2 instances and maintain availability
* Inputs
  
  See details [here](modules/aws_auto_scale/variables.tf).

* Outputs

  See details [here](modules/aws_auto_scale/outputs.tf).

### aws_webserver_network

* Overview
  
  The module sets up the security group, the elastic ip, and the route53 entries for www and non-www URLs.

* Inputs
  
  See details [here](modules/aws_webserver_network/variables.tf).

* Outputs

  See details [here](modules/aws_webserver_network/outputs.tf).