<!-- markdownlint-disable MD041 -->

## Content
1. [Terraform-nomad-minio](#terraform-nomad-minio)
2. [Compatibility](#compatibility)
3. [Requirements](#requirements)
    1. [Required modules](#required-modules)
    2. [Required software](#required-software)
4. [Usage](#usage)
    1. [Verifying setup](#verifying-setup)
5. [Example usage](#example-usage)
6. [Secrets & Credentials](#secrets--credentials)
    1. [Set credentials manually](#set-credentials-manually)
    2. [Set credentials using Vault secrets](#set-credentials-using-vault-secrets)
7. [Volumes](#volumes)


# Terraform-nomad-minio
Terraform-nomad-minio module is IaaC - infrastructure as a code. Module contains
a nomad job with [Minio](https://min.io).
- [consul](https://www.consul.io/docs/) service integration.
- [docker driver](https://www.nomadproject.io/docs/drivers/docker.html)

## Compatibility
| Software | OSS Version | Enterprise Version |
| :------- | :---------- | :-------- |
| Terraform | 1.0.7 or newer|  |
| Consul | 1.10.3 or newer | 1.10.3 or newer |
| Vault | 1.8.4 or newer | 1.8.4 or newer |
| Nomad | 1.1.6 or newer | 1.1.6 or newer |

## Requirements

### Required modules
No modules required.

### Required software
- [Consul](https://releases.hashicorp.com/consul/) binary available on `PATH`
  on the local machine.
- [Vault](https://releases.hashicorp.com/vault/) service available on specified
  port.

## Usage
The following command will run an example with standalone instance of Minio.

```text
terraform init
terraform plan
terraform apply
```

### Verifying setup
You can verify that Minio ran successful by checking the Minio UI on
[localhost:9000/](http://localhost:9000/).

## Example usage
These are the default values for the Minio module.

```hcl
module "minio" {
  source = "../.."

  # nomad
  nomad_datacenters  = ["dc1"]
  nomad_namespace    = "default"
  nomad_host_volume  = "persistence"

  # minio
  service_name       = "minio"
  host               = "127.0.0.1"
  port_static        = 9000
  image              = "minio/minio:latest"
  vault_secret       = {
                         use_vault_provider        = true,
                         vault_kv_policy_name      = "kv-secret",
                         vault_kv_path             = "secret/data/minio",
                         vault_kv_field_access_key = "access_key",
                         vault_kv_field_secret_key = "secret_key"
                       }
  volume_destination = "/data"
  envs               = ["SOME_VAR_N1=some-value"]
  use_host_volume    = true
  use_canary         = true
  use_vault_kms      = false
}
```

## Secrets & Credentials

### Set credentials manually
To set the credentials manually you first need to tell the module to not fetch
credentials from vault. To do that, set `vault_secret.use_vault_provider` to
`false` (see below for example). If this is done the module will use the
variables `access_key` and `secret_key` to set the Minio credentials. These will
default to `minio` and `minio123` if not set by the user.
Below is an example on how to disable the use of vault credentials, and setting
your own credentials.

```hcl
module "minio" {
...
  vault_secret = {
                    use_vault_provider        = false,
                    vault_kv_path             = "",
                    vault_kv_field_access_key = "",
                    vault_kv_field_secret_key = ""
                 }
  access_key     = "some-user-provided-access-key"
  secret_key     = "some-user-provided-secret-key"
```

### Set credentials using Vault secrets
If you want to use the vault stored credentials, you can do so by changing the
 `vault_secret` object similar to below:

```hcl
module "minio" {
...
  vault_secret  = {
                    use_vault_provider        = true,
                    vault_kv_policy_name      = "kv-secret"
                    vault_kv_path             = "secret/minio",
                    vault_kv_field_access_key = "access_key",
                    vault_kv_field_secret_key = "secret_key"
                  }
}
```

## Volumes
We are using
[host volume](https://www.nomadproject.io/docs/job-specification/volume) to
store Minio data. Minio data will now be available in the `persistence/minio`
folder.
