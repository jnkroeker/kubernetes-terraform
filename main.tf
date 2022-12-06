terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.39.0"
        }
    }
}

provider "google" {
    credentials = file("./credentials/gcp-service-account.json")

    project = var.project
    region  = var.region
    zone    = var.zone
}