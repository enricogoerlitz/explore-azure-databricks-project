variable "project_resourcegroup_name" {
  description = "The name of the resource group for the project"
  type        = string
  default     = "explore-azure-databricks-project-euwest-rg"

}

variable "project_acr_name" {
  description = "The name of the Azure Container Registry for the project"
  type        = string
  default     = "eadbprojectweucr"
}

variable "default_tags" {
  description = "The default tags for all resources"
  type        = map(string)
  default = {
    "project" = "explore-azure-databricks"
  }
}

variable "westeurope_location" {
  description = "The location for the resources"
  type        = string
  default     = "westeurope"
}

variable "app_service_plan_sku_name" {
  description = "The SKU name for the App Service Plan. Specified in the environment variables."
  type        = string
  default     = "EP1"
}
