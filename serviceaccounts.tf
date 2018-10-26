variable project { }

provider "google" {
  project = "${var.project}"
}

resource "google_service_account" "worker" {
  account_id   = "travis-ci-worker"
  display_name = "Travis CI Workers"
  project      = "${var.project}"
}

resource "google_project_iam_custom_role" "worker" {
  role_id     = "worker"
  title       = "Travis CI Workers"
  description = "A travis-worker process that can do travis-worky stuff"

  permissions = [
    "cloudtrace.traces.patch",
    "compute.acceleratorTypes.get",
    "compute.acceleratorTypes.list",
    "compute.addresses.create",
    "compute.addresses.createInternal",
    "compute.addresses.delete",
    "compute.addresses.deleteInternal",
    "compute.addresses.get",
    "compute.addresses.list",
    "compute.addresses.setLabels",
    "compute.addresses.use",
    "compute.addresses.useInternal",
    "compute.diskTypes.get",
    "compute.diskTypes.list",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.disks.delete",
    "compute.disks.get",
    "compute.disks.getIamPolicy",
    "compute.disks.list",
    "compute.disks.resize",
    "compute.disks.setIamPolicy",
    "compute.disks.setLabels",
    "compute.disks.update",
    "compute.disks.use",
    "compute.disks.useReadOnly",
    "compute.globalOperations.get",
    "compute.globalOperations.list",
    "compute.images.list",
    "compute.images.useReadOnly",
    "compute.instances.addAccessConfig",
    "compute.instances.addMaintenancePolicies",
    "compute.instances.attachDisk",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.deleteAccessConfig",
    "compute.instances.detachDisk",
    "compute.instances.get",
    "compute.instances.getGuestAttributes",
    "compute.instances.getIamPolicy",
    "compute.instances.getSerialPortOutput",
    "compute.instances.list",
    "compute.instances.listReferrers",
    "compute.instances.osAdminLogin",
    "compute.instances.osLogin",
    "compute.instances.removeMaintenancePolicies",
    "compute.instances.reset",
    "compute.instances.setDeletionProtection",
    "compute.instances.setDiskAutoDelete",
    "compute.instances.setIamPolicy",
    "compute.instances.setLabels",
    "compute.instances.setMachineResources",
    "compute.instances.setMachineType",
    "compute.instances.setMetadata",
    "compute.instances.setMinCpuPlatform",
    "compute.instances.setScheduling",
    "compute.instances.setServiceAccount",
    "compute.instances.setShieldedVmIntegrityPolicy",
    "compute.instances.setTags",
    "compute.instances.start",
    "compute.instances.startWithEncryptionKey",
    "compute.instances.stop",
    "compute.instances.update",
    "compute.instances.updateAccessConfig",
    "compute.instances.updateNetworkInterface",
    "compute.instances.updateShieldedVmConfig",
    "compute.instances.use",
    "compute.instanceGroups.get",
    "compute.instanceGroups.list",
    "compute.machineTypes.get",
    "compute.machineTypes.list",
    "compute.networks.get",
    "compute.networks.list",
    "compute.networks.use",
    "compute.projects.get",
    "compute.regions.get",
    "compute.regions.list",
    "compute.subnetworks.get",
    "compute.subnetworks.list",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp",
    "compute.zoneOperations.get",
    "compute.zoneOperations.list",
    "compute.zones.get",
    "compute.zones.list",
  ]
}

resource "google_project_iam_member" "worker" {
  project = "${var.project}"
  role    = "projects/${var.project}/roles/${google_project_iam_custom_role.worker.role_id}"
  member  = "serviceAccount:${google_service_account.worker.email}"
}

resource "google_service_account_key" "worker" {
  service_account_id = "${google_service_account.worker.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}


resource "google_service_account" "cleanup" {
  account_id   = "travis-ci-vm-cleanup"
  display_name = "Travis CI VM Cleanup"
  project      = "${var.project}"
}

resource "google_project_iam_custom_role" "cleanup" {
  role_id     = "cleanup"
  title       = "Travis CI VM Cleanup"
  description = "A gcloud-cleanup process that can clean and archive stuff"

  permissions = [ "cloudtrace.traces.patch",
    "compute.disks.delete",
    "compute.disks.get",
    "compute.disks.list",
    "compute.disks.update",
    "compute.globalOperations.get",
    "compute.globalOperations.list",
    "compute.images.delete",
    "compute.images.get",
    "compute.images.list",
    "compute.instances.delete",
    "compute.instances.deleteAccessConfig",
    "compute.instances.detachDisk",
    "compute.instances.get",
    "compute.instances.getSerialPortOutput",
    "compute.instances.list",
    "compute.instances.reset",
    "compute.instances.stop",
    "compute.instances.update",
    "compute.regions.get",
    "compute.regions.list",
    "compute.zones.get",
    "compute.zones.list",
    "storage.objects.create",
    "storage.objects.update",
  ]
}

resource "google_project_iam_member" "cleanup" {
  project = "${var.project}"
  role    = "projects/${var.project}/roles/${google_project_iam_custom_role.cleanup.role_id}"
  member  = "serviceAccount:${google_service_account.cleanup.email}"
}

resource "google_service_account_key" "cleanup" {
  service_account_id = "${google_service_account.cleanup.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}


output "worker_account_json" {
  value = "${base64decode(google_service_account_key.worker.private_key)}"
}

output "cleanup_account_json" {
  value = "${base64decode(google_service_account_key.cleanup.private_key)}"
}

output "worker_service_account_email" {
  value = "${google_service_account.worker.email}"
}
