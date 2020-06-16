resource "digitalocean_kubernetes_cluster" "zeeders" {
  name    = var.cluster_name
  region  = var.cluster_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.cluster_version
  tags    = ["staging"]

  node_pool {
    name       = var.pool_name_1
    size       = var.pool_size
    node_count = 2
  }
}

# Create a new Jenkins server
resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-18-04-x64"
  name   = "Jenkins"
  region = var.cluster_region
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    var.ssh_fingerprint,
  ]

  provisioner "file" {
    source      = "install-jenkins.sh"
    destination = "/tmp/install-jenkins.sh"
  }

  connection {
    user        = "root"
    host        = self.ipv4_address
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-jenkins.sh",
      "/tmp/install-jenkins.sh",
    ]
  }
}
