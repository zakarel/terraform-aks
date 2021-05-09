# AKS Terraforming
## Public Cluster Terraforming

<img src="https://img.shields.io/badge/Azure%20CLI%20-v2.19.1-blue?style=flat-square">   <img src="https://img.shields.io/badge/VSCode%20-v1.53.2-purple?style=flat-square">

### Dependencies:
* Azure CLI
* Terraform
* kubectl

### Signin:
#### Connect to Azure with Azure CLI:
```
az login
```
#### Choosing the Subsription
```
az account list -o table
az account set -s 'XXX-XXX'
```

### Cloning the project:
```
git clone https://github.com/hashicorp/learn-terraform-provision-aks-cluster`
```
### Pre-Installation:
#### Creating the Service Principal
```
az ad sp create-for-rbac --skip-assignment -n "aks1-eastus"
```
Copy the appId and password from the output
#### Entering the vars in terraform.tfvars
```
appId    = "XXXX-xxxxx-XXXXX-xxxx"
password = "xxxx-XXXX-xxx-XXXX"
```
### Installation:
```
terraform init
```
Wait for the "Terraform has been successfully initialized!" message
```
terraform plan -out plan1
```
Make sure the plan output is what you intended it to be and run the following:
```
terraform apply plan1
```
### Post-Installation: 
#### Configure AKS cred
```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```
#### Test with the following:
```
kubectl get no
```
## Authors

* **Tzahi Ariel** - *Initial work* - [zakarel](https://github.com/zakarel)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
