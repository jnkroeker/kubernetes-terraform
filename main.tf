terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.14.0"
        }
    }
}

provider "google" {
    credentials = file("./certs/k8s-the-hard-way-tf-342523-a8c92947c013.json")

    project = var.project
    region  = var.region
    zone    = var.zone
}