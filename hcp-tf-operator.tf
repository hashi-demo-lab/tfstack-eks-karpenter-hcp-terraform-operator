#create kubernetes namespace
resource "kubernetes_namespace" "operator" {
  metadata {
    name = var.tfc_operator_namespace
  }
}

#create kubernetes namespace for HCP Terraform agents
resource "kubernetes_namespace" "agents" {
  metadata {
    name = "hcp-agents"
  }
}


resource "kubernetes_secret" "operator" {
  count = var.create_tfc_operator ? 1 : 0

  metadata {
    name      = "hcp-operator"
    namespace = kubernetes_namespace.agents.metadata.0.name
  }

  data = {
    token = var.tfc_operator_token
  }
}

# Terraform Cloud Operator for K8s helm chart
resource "helm_release" "operator" {
  count = var.create_tfc_operator ? 1 : 0

  name       = "terraform-cloud-operator"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "terraform-cloud-operator"
  version    = var.tfc_operator_version
  namespace  = kubernetes_namespace.operator.metadata.0.name
  values = [
    file("${path.module}/values.yaml")
  ]

}



# resource "kubernetes_manifest" "operator" {
#   count    = var.create_tfc_operator ? 1 : 0
#   manifest = provider::kubernetes::manifest_decode(file("${path.module}/tfc-operator.yaml"))
#   field_manager {
#     # set the name of the field manager
#     name = "manager"

#     # force field manager conflicts to be overridden
#     force_conflicts = true
#   }
# }