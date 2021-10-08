variable "nomad_provider_address" {
  description = "Nomad cluster address."
  type        = string
  default     = "https://127.0.0.1:4646"
}

variable "nomad_acl" {
  description = "Nomad ACLs enabled/disabled"
  type        = bool
  default     = false
}
