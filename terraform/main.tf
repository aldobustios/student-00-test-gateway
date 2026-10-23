terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

locals {
  catalog_name = "${var.namespace}-catalog"
}

resource "null_resource" "apic_catalog" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
set -e

echo "Using username: $TF_VAR_apic_username"
echo "Password length: $(echo -n "$TF_VAR_apic_password" | wc -c)"

TOKEN_RESPONSE=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/token" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"$TF_VAR_apic_username\",
    \"password\": \"$TF_VAR_apic_password\",
    \"realm\": \"provider/default-idp-2\",
    \"client_id\": \"caa87d9a-8cd7-4686-8b6e-ee2cdc5ee267\",
    \"client_secret\": \"3ecff363-7eb3-44be-9e07-6d4386c48b0b\",
    \"grant_type\": \"password\"
  }")

echo "TOKEN RESPONSE: $TOKEN_RESPONSE"

TOKEN=$(echo $TOKEN_RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

RESULT=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/orgs/${var.apic_org_name}/catalogs" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"${local.catalog_name}\",
    \"title\": \"${var.namespace} Catalog\"
  }")

echo "Catalog result: $RESULT"
echo $RESULT | python3 -c "import sys,json; d=json.load(sys.stdin); print('CATALOG_ID=' + d.get('id','ERROR'))"
EOT
  }
}
