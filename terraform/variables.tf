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
  description = "APIC labadmin username"
  type        = string
  default     = "labadmin"
}

variable "apic_password" {
  description = "APIC labadmin password"
  type        = string
  sensitive   = true
  default     = "LabAdmin2026!"
}

variable "apic_org_name" {
  description = "APIC Provider Organization name"
  type        = string
  default     = "lab-organization"
}

variable "apic_admin_org_id" {
  description = "APIC admin org ID"
  type        = string
  default     = "2a2814d7-ef3d-45ac-b601-209bed720fb5"
}

variable "apic_availability_zone_id" {
  description = "APIC availability zone ID"
  type        = string
  default     = "8003833e-f5c5-4c5b-ae9f-5e7cc95f771e"
}

variable "apic_gateway_service_id" {
  description = "APIC gateway service ID"
  type        = string
  default     = "82539bc5-ed67-4105-8ba7-c2d71e81140f"
}

variable "gateway_name" {
  description = "Name of the API/gateway"
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
