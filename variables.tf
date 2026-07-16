variable "location" {
  description = "The Azure region for the resources"
  type        = string
  default     = "Switzerland North"
}

variable "environment" {
  description = "The deployment environment (e.g., Production, Staging)"
  type        = string
  default     = "Production"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "project-vault"
}