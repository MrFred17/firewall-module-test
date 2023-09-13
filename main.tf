# Define the variables for the module
variable "resource_group_name" {
  description = "The name of the Azure resource group where the firewall will be created."
}

variable "firewall_name" {
  description = "The name of the Azure Firewall."
}

variable "public_ip_name" {
  description = "The name of the Azure Public IP address for the firewall."
}

variable "firewall_sku_tier" {
  description = "The tier of the Azure Firewall (Standard or Premium)."
  default     = "Standard"
}

variable "firewall_sku_capacity" {
  description = "The capacity of the Azure Firewall (1, 2, or 4)."
  default     = 2
}

# Create the Azure resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "westeurope" # Change to your desired Azure region
}

# Create the Azure Firewall
resource "azurerm_firewall" "example" {
  name                = var.firewall_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku {
    tier = var.firewall_sku_tier
    capacity = var.firewall_sku_capacity
  }
}

# Create a Public IP address for the Firewall
resource "azurerm_public_ip" "example" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku {
    name = "Standard"
  }
}

# Associate the Public IP address with the Firewall
resource "azurerm_firewall_public_ip_configuration" "example" {
  name                = "example"
  firewall_name       = azurerm_firewall.example.name
  resource_group_name = azurerm_resource_group.example.name
  public_ip_address_id = azurerm_public_ip.example.id
}

# Output the Azure Firewall information
output "firewall_id" {
  value = azurerm_firewall.example.id
}

output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}
