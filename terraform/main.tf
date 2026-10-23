terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.65"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}

resource "ibm_apic_gateway" "nano" {
  name        = "test-gateway"
  namespace   = "student-00"
  environment = "dev"
  replicas    = 1

  gateway_type = "datapower-api-gateway"

  apic_cluster = var.apic_cluster_endpoint

  lifecycle {
    ignore_changes = [name]
  }
}

output "gateway_endpoint" {
  value = ibm_apic_gateway.nano.endpoint_url
}

output "gateway_name" {
  value = ibm_apic_gateway.nano.name
}
