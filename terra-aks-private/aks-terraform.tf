# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Creating the RG
resource "azurerm_resource_group" "terraformrg" {
  name     = "rg-aks-eastus"
  location = "East US"

  tags = {
    environment = "terraform-aks"
  }
}
# Creating the NSG
resource "azurerm_network_security_group" "terraformnsg" {
  name                = "nsg-aks-eastus"
  location            = azurerm_resource_group.terraformrg.location
  resource_group_name = azurerm_resource_group.terraformrg.name
}

# Creating the VNET
resource "azurerm_virtual_network" "terraformvnet" {
  name                = "vnet-aks-eastus"
  location            = azurerm_resource_group.terraformrg.location
  resource_group_name = azurerm_resource_group.terraformrg.name
  address_space       = ["10.0.0.0/16"]
}
# Creating 3 Subnets
resource "azurerm_subnet" "terraformsubnet1" {
  name                 = "snet-aks1"
  resource_group_name  = azurerm_resource_group.terraformrg.name
  virtual_network_name = azurerm_virtual_network.terraformvnet.name
  address_prefixes     = "10.0.1.0/24"
}
resource "azurerm_subnet" "terraformsubnet2" {
  name                 = "snet-aks2"
  resource_group_name  = azurerm_resource_group.terraformrg.name
  virtual_network_name = azurerm_virtual_network.terraformvnet.name
  address_prefixes     = "10.0.2.0/24"
}
resource "azurerm_subnet" "terraformsubnet3" {
  name                 = "snet-aks3"
  resource_group_name  = azurerm_resource_group.terraformrg.name
  virtual_network_name = azurerm_virtual_network.terraformvnet.name
  address_prefixes     = "10.0.3.0/24"
}

# Creating the AKS Cluster
resource "azurerm_kubernetes_cluster" "terraformaks" {
  name                = "aks-eastus"
  location            = azurerm_resource_group.terraformrg.location
  resource_group_name = azurerm_resource_group.terraformrg.name
  dns_prefix          = "ateam-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.terraformsubnet1.id
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "terraform-aks"
  }
}
