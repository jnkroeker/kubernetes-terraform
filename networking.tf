######
# VPC and Subnet section
######

# this creates a dedicated VPC to host the Kubernetes cluster

resource "google_compute_network" "k8s_network" {
    auto_create_subnetworks = false
    name                    = "k8s-network"
}

# 10.240.0.0/24 address range can host up to 254 compute instances

resource "google_compute_subnetwork" "k8s_subnet" {
    network       = google_compute_network.k8s_network.self_link
    ip_cidr_range = "10.240.0.0/24"
    region        = var.region 
    name          = "k8s-subnet"
}

######
# Firewalls section
######

# allow internal communication across all protocols

resource "google_compute_firewall" "allow_all_internal" {
    name    = "k8s-internal-firewall"
    network = google_compute_network.k8s_network.name

    # omiting 'ports' list attribute all ports open to this protocol 
    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
    }

    allow {
        protocol = "udp"
    }

    source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

# allow external communication on SSH, ICMP, HTTPS

resource "google_compute_firewall" "allow_all_external" {
    name    = "k8s-external-firewall"
    network = google_compute_network.k8s_network.name

    allow {
        protocol = "tcp"
        ports    = ["22", "6443"]
    }

    allow {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
}

######
# Static IP section
######

# static ip for the external load balancer fronting the k8s API servers.
# this public ip allows for communication with instances outside the network created above
# (ie internet traffic)

resource "google_compute_address" "k8s_staticip" {
   name  = "k8s-static-ip"
   region= var.region
}