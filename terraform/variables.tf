variable "k8s_host" {
  description = "Kubernetes API server URL"
  type        = string
  default     = "https://api.itz-jyz46m.infra01-lb.wdc07.techzone.ibm.com:6443"
}

variable "k8s_token" {
  description = "Kubernetes service account token"
  type        = string
  sensitive   = true
}

variable "k8s_ca_cert" {
  description = "Kubernetes cluster CA certificate (base64)"
  type        = string
  sensitive   = true
}

variable "gateway_name" {
  description = "Name of the gateway"
  type        = string
  default     = "test-gateway"
}

variable "namespace" {
  description = "Student namespace in OpenShift"
  type        = string
  default     = "student-00"
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
