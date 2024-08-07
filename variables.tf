variable "project" {
    type = string
    description = "The GCP project"
}

variable "region" {
    type = string
    description = "The GCP region"
    default = "us-central1"
}

variable "zone" {
    type = string
    description = "The GCP zone"
    default = "us-central1-b"
}

variable "ssh_public_key" {
    type = string
    description = "The SSH public key string for the admin user"
}

variable "authcodes" {
    type = string
    description = "The VM-Flex deployment profile"
}

variable "label" {
    type = string
    description = "The Strata Cloud Manager label"
}

variable "cert-pin-id" {
    type = string
    description = "The certificate request PIN ID"
}

variable "cert-pin-value" {
    type = string
    description = "The certificate request PIN value"
}