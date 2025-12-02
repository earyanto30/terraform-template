terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "<prefix>"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "<location>"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "<your-ssh-public-key>"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}