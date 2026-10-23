variable "apic_platform_endpoint" {
  description = "APIC Platform API endpoint"
  type        = string
  default     = "https://apic-lab-mgmt-platform-api-apic.apps.itz-jyz46m.infra01-lb.wdc07.techzone.ibm.com"
}

variable "apic_manager_endpoint" {
  description = "APIC API Manager endpoint"
  type        = string
  default     = "https://apic-lab-mgmt-api-manager-apic.apps.itz-jyz46m.infra01-lb.wdc07.techzone.ibm.com"
}

variable "apic_username" {
  description = "APIC admin username"
  type        = string
  sensitive   = true
}

variable "apic_password" {
  description = "APIC admin password"
  type        = string
  sensitive   = true
}

variable "gateway_name" {
  description = "Name of the gateway/API"
  type        = string
  default     = "test-gateway"
}

variable "namespace" {
  description = "Student namespace"
  type        = string
  default     = "student-00"
}

variable "environment" {
  description = "Target environment"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}
