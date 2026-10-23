terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "apic_api" {
  triggers = {
    gateway_name = var.gateway_name
    namespace    = var.namespace
    environment  = var.environment
    replicas     = var.replicas
  }

  provisioner "local-exec" {
    command = <<EOT
      TOKEN=$(curl -sk -X POST \
        "${var.apic_platform_endpoint}/api/token" \
        -H "Content-Type: application/json" \
        -d "{
          \"username\": \"${var.apic_username}\",
          \"password\": \"${var.apic_password}\",
          \"realm\": \"admin/default-idp-1\",
          \"client_id\": \"caa87d9a-8cd7-4686-8b6e-ee2cdc5ee267\",
          \"client_secret\": \"3ecff363-7eb3-44be-9e07-6d4386c48b0b\",
          \"grant_type\": \"password\"
        }" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

      curl -sk -X POST \
        "${var.apic_manager_endpoint}/api/orgs/lab-organization/drafts/draft-apis" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
          \"draft_api\": {
            \"info\": {
              \"title\": \"${var.namespace}-${var.gateway_name}\",
              \"name\": \"${var.namespace}-${var.gateway_name}\",
              \"version\": \"1.0.0\",
              \"x-ibm-name\": \"${var.namespace}-${var.gateway_name}\"
            },
            \"openapi\": \"3.0.0\",
            \"paths\": {},
            \"x-ibm-configuration\": {
              \"gateway\": \"datapower-api-gateway\",
              \"type\": \"rest\",
              \"phase\": \"realized\",
              \"enforced\": true,
              \"cors\": {\"enabled\": true},
              \"assembly\": {
                \"execute\": [{
                  \"invoke\": {
                    \"title\": \"invoke\",
                    \"version\": \"2.0.0\",
                    \"target-url\": \"https://httpbin.org/get\",
                    \"timeout\": 60,
                    \"verb\": \"keep\"
                  }
                }]
              }
            }
          }
        }"
    EOT
  }
}
