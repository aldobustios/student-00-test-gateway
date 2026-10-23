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

variable "apic_org_id" {
  description = "APIC Provider Organization ID"
  type        = string
  default     = "0d6d16d4-dab5-48b2-880c-803ce4a70592"
}

variable "gateway_name" {
  description = "Name of the API"
  type        = string
  default     = "hello-world"
}

variable "namespace" {
  description = "Student namespace"
  type        = string
  default     = "student-00"
}
