variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "public_ip" {
  description = "Public IP for ingress"
  type        = string
}

variable "ssh_public_key" {
  description = "Public key for ssh"
  type        = string
}
