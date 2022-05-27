variable "do_token" {
  description = "Access token for DigitalOcean API (`tf.sh` reads token from local file which is not pushed to the remote git repo)"
  type        = string
  sensitive   = true
}

variable "do_region" {
  description = "Default location for DigitalOcean resources (= Frankfurt)"
  type        = string
  default     = "fra"
}

variable "do_instance_smallest" {
  description = "Smallest DigitalOcean instance type"
  type        = string
  default     = "basic-xxs"
}

variable "do_base_domain" {
  description = "Domain used for DigitalOcean -> all Services will act as subdomains to this base domain name"
  type        = string
  default     = "cloud.sommerfeld.io"
}

# ----------------------------------------------------------------------------------------------------------------------

variable "linode_token" {
  description = "Access token for Linode API (`tf.sh` reads token from local file which is not pushed to the remote git repo)"
  type        = string
  sensitive   = true
}

variable "linode_region" {
  description = "Default location for Linode resources (= Frankfurt)"
  type        = string
  default     = "eu-central"
}

variable "linode_instance_smallest" {
  description = "Linode resources size: `Nanode 1GB`"
  type        = string
  default     = "g6-nanode-1"
}

variable "linode_base_domain" {
  description = "Domain used for Linode -> all Services will act as subdomains to this base domain name"
  type        = string
  default     = "linode.sommerfeld.io"
}