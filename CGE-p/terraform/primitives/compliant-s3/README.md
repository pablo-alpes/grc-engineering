terraform deployment of the resource into AWS :

1. terraform init : downloads aws and random providers into .terraform/
2. terraform validate: checks .tf (valid or invalid)
3. terraform plan -out=tfplan: Plan: 6 to add, 0 to change, 0 to destroy.
4. terraform apply -auto-approve tfplan : applies the diff, state file updated + signed



5. capture evidences : mkdir -p ../../../evidence/lab-2-3
terraform show -json tfplan > ../../../evidence/lab-2-3/plan.json
terraform show -json        > ../../../evidence/lab-2-3/state.json