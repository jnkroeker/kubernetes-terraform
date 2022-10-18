######
# Controller Nodes
######

# Provision 3 compute instances with Ubuntu Server because of its 
# support of Containerd container runtime, each with a fixed
# private IP address

# When connecting to compute instances for the first time, SSH keys
# will be generated for you and stored in the project or instance metadata

resource "google_compute_instance" "k8s_controller" {
   boot_disk {
       auto_delete = true

        initialize_params {
            image = var.controller_image
            size  = var.controller_size
        }
    }

    can_ip_forward = true
    count          = var.controller_count
    machine_type   = var.controller_type
    name           = "k8s-controller-${count.index}"

    network_interface {
        access_config {}
        network_ip     = "10.240.0.1${count.index}"
        subnetwork    = google_compute_subnetwork.k8s_subnet.name
    }

    service_account {
        scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
    }

    tags = ["controller"]
}

######
# Worker Nodes
######

# Each worker instance requires a pod subnet allocation from the Kubernetes cluster CIDR range.
# The pod subnet allocation will be used to configure container networking.
# `pod-cidr` metadata will be used to expose pod subnet allocations to compute instances at runtime

resource "google_compute_instance" "k8s_worker" {
    boot_disk {
        auto_delete = true

        initialize_params {
            image = var.worker_image
            size  = var.worker_size
        }
    }

    can_ip_forward = true 
    count          = var.worker_count
    machine_type   = var.worker_type 
    name           = "k8s-worker-${count.index}"

    metadata = {
        pod-cidr = "10.200.${count.index}.0/24"
    }

    network_interface {
        # access_config (even empty) gives each worker and external ip
        # making it accessible to my scripts to ssh and install certs, etc
        access_config {}
        network_ip     = "10.240.0.2${count.index}"
        subnetwork    = google_compute_subnetwork.k8s_subnet.name 
    }

    service_account {
        scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
    }

    tags = ["worker"]
}