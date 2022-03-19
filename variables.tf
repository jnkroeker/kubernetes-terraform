variable "project" {
    default = "k8s-the-hard-way-tf-342523"
}

variable "region" {
    default = "us-east4"
}

variable "zone" {
    default = "us-east4-a"
}

######
# Controller-specific variables 
######

variable "controller_image" {
    default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "controller_size" {
    default = 200
}

variable "controller_count" {
    default = 3
}

variable "controller_type" {
    default = "e2-standard-2" 
}

######
# Worker-specific variables
######

variable "worker_image" {
    default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "worker_size" {
    default = 200
}

variable "worker_count" {
    default = 3
}

variable "worker_type" {
    default = "e2-standard-2" 
}