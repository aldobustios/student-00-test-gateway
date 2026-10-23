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
  name        = "${{ values.gateway_name }}"
  namespace   = "${{ values.namespace }}"
  environment = "${{ values.environment }}"
  replicas    = ${{ values.replicas }}

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
