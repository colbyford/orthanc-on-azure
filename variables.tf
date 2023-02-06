variable "tag_department" {
  type    = string
  default = "test_dept"
}

variable "tag_business_owner" {
  type    = string
  default = "test_manager"
}


variable "tag_region" {
  type    = string
  default = "eastus"
}

variable "location" {
  description = "Location of Resource Group"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["westus3", "westus2", "westus", "eastus"], lower(var.location))
    error_message = "Unsupported Azure Region specified."
  }
}


// Azure-Specific App Variables

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application Name"
  type        = string
  default     = "orthanc"
}
