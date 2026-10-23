variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key"
  type        = string
  sensitive   = true
}

variable "apic_cluster_endpoint" {
  description = "IBM API Connect platform API endpoint"
  type        = string
  default     = "https://apic-lab-mgmt-platform-api-apic.apps.itz-jyz46m.infra01-lb.wdc07.techzone.ibm.com"
}

variable "gateway_name" {
  description = "Name of the gateway"
  type        = string
}

variable "environment" {
  description = "Target environment: dev, staging or production"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Number of gateway replicas"
  type        = number
  default     = 1
}

variable "namespace" {
  description = "Student namespace in OpenShift"
  type        = string
}
