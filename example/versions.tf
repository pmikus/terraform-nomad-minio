terraform {
  backend "consul" {
    address = "consul.service.consul:8500"
    scheme  = "http"
    path    = "terraform/minio"
  }
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = ">= 1.4.16"
    }
    #vault = {
    #  version = ">= 3.2.1"
    #}
  }
  required_version = ">= 1.3.6"
}
