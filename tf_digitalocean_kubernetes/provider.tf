
provider "kubernetes" {
  load_config_file = false
  host  = digitalocean_kubernetes_cluster.zeeders.endpoint
  token = digitalocean_kubernetes_cluster.zeeders.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.zeeders.kube_config[0].cluster_ca_certificate
  )
}


# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}