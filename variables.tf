variable "prefix" {
  description = "The prefix used for all resources in this example."
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  type        = string
}

variable "net_address_space" {
  description = "The IP address space of the Virtual Machine VNet."
  type        = string
}

variable "net_address_space_subnet" {
  description = "The prefix IP address space of the Virtual Machine VNet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "rdp_port" {
  description = "The RDP port to allow inbound traffic for."
  type        = string
}

variable "mssql_port" {
  description = "The MSSQL port to allow inbound traffic for."
  type        = string
}

variable "sql_version" {
  description = "The version of the Azure VM image."
  type        = string
  validation {
    condition     = contains(["SQL2022", "SQL2019", "SQL2017", "SQL2016"], var.sql_version)
    error_message = "The SQL Version value must be either SQL2022, SQL2019, SQL2017 or SQL2016'."
  }
}

variable "image_sku" {
  description = "The SKU of the Azure VM image."
  type        = string
  validation {
    condition     = contains(["enterprise", "developer", "standard"], var.image_sku)
    error_message = "The sku value must be either 'standard', 'enterprise' or 'developer'."
  }
}

variable "timezone" {
  description = "The timezone for the Windows virtual machine."
  type        = string
  default     = "UTC"
}

variable "computer_name" {
  description = "The name assigned to the computer."
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS14_v2"
}

variable "enable_telemetry" {
  description = "Enable/disable telemetry for the module."
  type        = bool
  default     = true
}


