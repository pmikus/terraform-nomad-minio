provider "nomad" {
  address   = var.nomad_provider_address
  alias     = "vagrant"
  ca_file   = var.nomad_provider_ca_file
  cert_file = var.nomad_provider_cert_file
  key_file  = var.nomad_provider_key_file
}
