resource "kubernetes_namespace_v1" "longhorn_system" {
  metadata {
    name = "longhorn-system"
  }
}

module "longhorn" {
  source    = "./module/storage/longhorn"
  namespace = kubernetes_namespace_v1.longhorn_system.metadata.0.name

  dashboard_host   = "longhorn.cortex.reducer.io"
  default_replicas = 1
}

# Create a storage class that only uses a single replica
resource "kubernetes_storage_class_v1" "longhorn_single_replica" {
  metadata {
    name = "longhorn-single-replica"

  }

  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"

  parameters = {
    numberOfReplicas    = 1
    fsType              = "ext4"
    staleReplicaTimeout = 30
    dataLocality        = "disabled"
    fromBackup          = ""
  }
}