terraform deployment of the resource into AWS :

1. terraform init : downloads aws and random providers into .terraform/
2. terraform validate: checks .tf (valid or invalid)
3. terraform plan : Plan: 6 to add, 0 to change, 0 to destroy.
4. terraform apply : applies the diff, state file updated + signed