# For convenience in simple configurations, a child module automatically
# inherits default (un-aliased) provider configurations from its parent.
# This means that explicit provider blocks appear only in the root module,
# and downstream modules can simply declare resources for that provider
# and have them automatically associated with the root provider
# configurations.

module "minio" {
  providers = {
    nomad = nomad.razer
  }
  source = "../"


  # nomad
  datacenters   = ["razer"]
  volume_source = "volume-glacier"

  # minio
  job_name     = "minio"
  service_name = "minio"
  vault_secret = {
    use_vault_provider        = false,
    vault_kv_policy_name      = "kv-secret",
    vault_kv_path             = "secret/data/minio",
    vault_kv_field_access_key = "access_key",
    vault_kv_field_secret_key = "secret_key"
  }
  use_host_volume    = true
  volume_destination = "/data"
}
