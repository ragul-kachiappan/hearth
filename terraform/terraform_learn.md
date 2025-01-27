## Basic commands
```
terraform init # after creating config files
terraform plan # which scans the AWS account and checks if the resource needs to be created
terraform apply # To apply the changes to infra
terraform destroy # To destroy the created resources
terraform import # TODO
```
## Basics
- Data blocks reference an existing resource within AWS

### Variables
- Input Variables
  Referenced with var.<name>
  Eg:
```
  variable "instance_type" {
    description = "ec2 instance type"
    type = string
    default = "t2.micro"
  }
```

- Local Variables
  Referenced with local.<name>
  used as local scope variables for identifiers that are repeated throughout the config
```
locals {
  service_name = "My service"
  owner = "DevOps Directive"
}
```

- Output Variables
  used when some values need to returned from terraform apply that needs to consumed by another resource
```
output "instance_ip_addr {
  value = aws_instance.instance.public_ip
}
```
### Setting Input Variables
(order of precedence : lowest -> highest)
- Manual entry during plan/apply
- Default value in declaration block
- TF_VAR_<name> environment variables
- terraform.tfvars file
- *.auto.tfvars file
- CLI -var or -var-file

### Types & Validation
Primitive Types:
- string
- number
- bool

Complex Types:
- list(<TYPE>)
- set(<TYPE>)
- map(<TYPE>)
- object({<ATTR NAME> = <TYPE>, ...})
- tuple([<TYPE>,...])

Validation:
- Type checking happens automatically
- Custom conditions can also be enforced

### Sensitive Data
Mark variables as sensitive
sensitive = true

pass to terraform apply with:
TV_VAR_variable

-var (retrieved from secret manager at runtime)

Can also use external secret store, like AWS secrets manager

### Expressions and functions
Refer to docs
Basic logical, relational, templating, loop, constraints are available.
Builtin methods like Numeric, Date & Time, String, Collection, Encoding, Filesystem, etc are also available.

### Meta-Arguments

1. depends_on
specifies the dependency to enforce ordering
resource "aws_instance" "example" {
  depends_on = {
    aws_iam_role_policy.example,
  }
}

2. count
Allows for creation of multiple resources/modules from a single block

3. for_each
Allows for creation of multiple resources/modules from a single block
more control to customize each resource than count
Eg:
locals {
  subnet_ids = toset([
    "subnet-abc",
    "subnet-def",
  ])
}

resource "aws_instance" "server" {
  for_each = local.subnet_ids

  ami = ""
  instance_type = "t2.micro"
  subnet_id = each.key

  tags = {
    Name = "Server ${each.key}"
  }
}

4. Lifecycle
set of meta arguments to ctrl tf behaviour for specific resources
- create_before_destroy can help zero downtime deployments
- ignore_changes prevents Terraform from trying to revert metadata being set elsewhere
- prevent_destroy causes Terraform to reject any plan which would destroy this resource

### Provisioners
Perform action on local or remote machine
Eg: file, local-exec, remote-exec, Vendor like chef, puppet, ansible

### Modules
Package together a set of resource configs
Modules could sourced from anywhere local, github, tf registry, etc
Eg:
module "web_app" {
  source = "../web-app-module"


  bucket_name = "test-bucket"
  domain = "ragulk.com"
  db_name = "mydb"
  db_user = "foo"
  db_pass = var.db_pass
}
you can add  meta-arguments as well

What makes a good module?
- Raises the abstraction level from base resource types
- Groups resources in a logical fashion
- Exposes input variables to allow necessary customization + composition
- provides useful defaults
- returns outputs to make further integrations possible

### Multiple environments
2 main approaches
1. Workspaces - multiple named sections within a single backend
2. File Structure - Directory layout provides separation, modules provide reuse
tree:
modules/
dev/
  main.tf
  terraform.tfvars
production/
  main.tf
  terraform.tfvars
staging/
  main.tf
  terraform.tfvars

(environments + components)
- Further separation (at logical component groups) useful for larger projects
  - Isolate things that change frequently from those which don't
- Referencing resources across configurations is possible using terraform_remote_state
- Terragrunt acts on top of terraform to provide some comfort utilities

Environment name scoping eg:
locals {
  environment_name = terraform.workspace
}

module "web_app" {
  source = ""
  bucket_name = "test-tool-${local.environment_name}"
}