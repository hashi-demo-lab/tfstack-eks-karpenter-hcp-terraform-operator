variable "create_tfc_operator" {
  type    = bool
  default = true
}


variable "tfc_operator_token" {
  type      = string
  sensitive = true
}

variable "tfc_operator_namespace" {
  type    = string
  default = "hcp-operator"
}

variable "tfc_operator_version" {
  type        = string
  default     = "2.5.0"
  description = "Terraform Cloud Operator for K8s helm chart version"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}