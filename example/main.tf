# For convenience in simple configurations, a child module automatically
# inherits default (un-aliased) provider configurations from its parent.
# This means that explicit provider blocks appear only in the root module,
# and downstream modules can simply declare resources for that provider
# and have them automatically associated with the root provider
# configurations.

module "minio" {
  source = "../"
  providers = {
    nomad = nomad.dc1
  }

  # nomad
  datacenters = ["dc1"]
  host_volume = "volume-data1-1"

  # minio
  job_name        = "minio"
  group_count     = 1
  service_name    = "minio"
  host            = "http://10.0.2.15"
  port            = 9000
  container_image = "minio/minio:RELEASE.2021-07-27T02-40-15Z"
  vault_secret = {
    use_vault_provider        = false,
    vault_kv_policy_name      = "kv-secret",
    vault_kv_path             = "secret/data/minio",
    vault_kv_field_access_key = "access_key",
    vault_kv_field_secret_key = "secret_key"
  }
  data_dir        = "/data/"
  use_host_volume = true
  use_canary      = true
  envs            = ["MINIO_BROWSER=\"on\""]
}