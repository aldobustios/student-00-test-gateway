terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "kubernetes" {
  host                   = var.k8s_host
  token                  = var.k8s_token
  cluster_ca_certificate = base64decode(var.k8s_ca_cert)
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "datapower.ibm.com/v1beta3"
    kind       = "DataPowerService"
    metadata = {
      name      = var.gateway_name
      namespace = var.namespace
      labels = {
        app         = var.gateway_name
        environment = var.environment
        owner       = var.namespace
      }
    }
    spec = {
      replicas = var.replicas
      version  = "10.5.0.10"
      license = {
        accept     = true
        use        = "nonproduction"
        license    = "L-ACRR-ZTMKXU"
      }
      users = [{
        name              = "admin"
        accessLevel       = "privileged"
        passwordSecret    = "datapower-admin-credentials"
      }]
      gateway = {
        enabled = true
      }
    }
  }
}

output "gateway_name" {
  value = var.gateway_name
}

output "gateway_namespace" {
  value = var.namespace
}
