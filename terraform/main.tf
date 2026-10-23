terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

locals {
  api_name     = "${var.namespace}-${var.gateway_name}"
  catalog_name = "${var.namespace}-catalog"
}

# Step 1 - Create catalog
resource "null_resource" "apic_catalog" {
  triggers = {
    catalog_name = local.catalog_name
  }

  provisioner "local-exec" {
    command = <<EOT
set -e

TOKEN=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/token" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"${var.apic_username}\",
    \"password\": \"${var.apic_password}\",
    \"realm\": \"provider/default-idp-2\",
    \"client_id\": \"caa87d9a-8cd7-4686-8b6e-ee2cdc5ee267\",
    \"client_secret\": \"3ecff363-7eb3-44be-9e07-6d4386c48b0b\",
    \"grant_type\": \"password\"
  }" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

RESULT=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/orgs/${var.apic_org_name}/catalogs" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"${local.catalog_name}\",
    \"title\": \"${var.namespace} Catalog\"
  }")

echo "Catalog: $RESULT"
echo $RESULT | python3 -c "import sys,json; d=json.load(sys.stdin); print('CATALOG_ID=' + d.get('id','ERROR'))"
EOT
  }
}

# Step 2 - Create Draft API
resource "null_resource" "apic_draft_api" {
  depends_on = [null_resource.apic_catalog]

  triggers = {
    api_name = local.api_name
  }

  provisioner "local-exec" {
    command = <<EOT
set -e

TOKEN=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/token" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"${var.apic_username}\",
    \"password\": \"${var.apic_password}\",
    \"realm\": \"provider/default-idp-2\",
    \"client_id\": \"caa87d9a-8cd7-4686-8b6e-ee2cdc5ee267\",
    \"client_secret\": \"3ecff363-7eb3-44be-9e07-6d4386c48b0b\",
    \"grant_type\": \"password\"
  }" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

RESULT=$(curl -sk -X POST \
  "${var.apic_manager_endpoint}/api/orgs/${var.apic_org_name}/drafts/draft-apis" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"draft_api\": {
      \"info\": {
        \"title\": \"${local.api_name}\",
        \"version\": \"1.0.0\",
        \"x-ibm-name\": \"${local.api_name}\"
      },
      \"openapi\": \"3.0.0\",
      \"paths\": {
        \"/hello\": {
          \"get\": {
            \"summary\": \"Hello World\",
            \"operationId\": \"hello-get\",
            \"responses\": {\"200\": {\"description\": \"OK\"}}
          }
        }
      },
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
  }")

echo "Draft API: $RESULT"
EOT
  }
}

# Step 3 - Create Draft Product and publish
resource "null_resource" "apic_product_publish" {
  depends_on = [null_resource.apic_draft_api]

  triggers = {
    api_name     = local.api_name
    catalog_name = local.catalog_name
  }

  provisioner "local-exec" {
    command = <<EOT
set -e

TOKEN=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/token" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"${var.apic_username}\",
    \"password\": \"${var.apic_password}\",
    \"realm\": \"provider/default-idp-2\",
    \"client_id\": \"caa87d9a-8cd7-4686-8b6e-ee2cdc5ee267\",
    \"client_secret\": \"3ecff363-7eb3-44be-9e07-6d4386c48b0b\",
    \"grant_type\": \"password\"
  }" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

# Obtener el ID del catalog recien creado
CATALOG_ID=$(curl -sk -X GET \
  "${var.apic_platform_endpoint}/api/orgs/${var.apic_org_name}/catalogs/${local.catalog_name}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")

echo "Catalog ID: $CATALOG_ID"

# Crear draft product
PRODUCT_ID=$(curl -sk -X POST \
  "${var.apic_manager_endpoint}/api/orgs/${var.apic_org_name}/drafts/draft-products" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"draft_product\": {
      \"info\": {
        \"title\": \"${local.api_name}-product\",
        \"name\": \"${local.api_name}-product\",
        \"version\": \"1.0.0\"
      },
      \"product\": \"1.0.0\",
      \"visibility\": {
        \"view\": {\"type\": \"public\"},
        \"subscribe\": {\"type\": \"authenticated\"}
      },
      \"apis\": {
        \"${local.api_name}\": {\"name\": \"${local.api_name}:1.0.0\"}
      },
      \"plans\": {
        \"default-plan\": {
          \"title\": \"Default Plan\",
          \"rate-limits\": {\"default\": {\"value\": \"100/1hour\"}}
        }
      }
    }
  }" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")

echo "Product ID: $PRODUCT_ID"

# Publicar en el catalog
PUBLISH=$(curl -sk -X POST \
  "${var.apic_platform_endpoint}/api/catalogs/${var.apic_org_id}/$CATALOG_ID/publish-draft-product" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"draft_product_url\": \"${var.apic_platform_endpoint}/api/orgs/${var.apic_org_id}/drafts/draft-products/$PRODUCT_ID\"
  }")

echo "Publish result: $PUBLISH"
echo $PUBLISH | python3 -c "import sys,json; d=json.load(sys.stdin); print('STATE=' + d.get('state', str(d.get('message',''))))"

echo ""
echo "API disponible en:"
echo "https://apic-lab-gw-gateway-apic.apps.itz-jyz46m.infra01-lb.wdc07.techzone.ibm.com/lab-organization/${local.catalog_name}/hello"
EOT
  }
}
