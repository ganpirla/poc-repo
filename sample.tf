variable "instance_count" {
  description = "Number of compute instances to create"
  default     = 3
}

variable "availability_domains" {
  description = "List of availability domains"
  default     = ["<AVAILABILITY_DOMAIN_1>", "<AVAILABILITY_DOMAIN_2>", "<AVAILABILITY_DOMAIN_3>"]
}

variable "additional_block_volume_size" {
  description = "Size of the additional block volume to attach to each compute instance"
  default     = 50
}

resource "oci_core_vnic" "vnic" {
  count           = var.instance_count
  compartment_id  = var.compartment_ocid
  display_name    = "my-vnic-${count.index}"
  subnet_id       = "<EXISTING_SUBNET_OCID>"
}

resource "oci_core_instance" "compute_instance" {
  count               = var.instance_count
  compartment_id      = var.compartment_ocid
  display_name        = "${var.instance_name}-${count.index}"
  shape               = var.shape
  subnet_id           = oci_core_vnic.vnic[count.index].subnet_id
  image_id            = "<IMAGE_OCID>"

  # Additional block volume attachment
  boot_volume_id      = oci_core_boot_volume.boot_volume[count.index].id
  block_volume_ids    = [oci_core_block_volume.additional_block_volume[count.index].id]

  # Add tags to each compute instance
  tags = {
    "environment" = "production"
    "department"  = "engineering"
  }

  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = true
  }

  network_interface {
    subnet_id = oci_core_vnic.vnic[count.index].subnet_id
    vnic_id   = oci_core_vnic.vnic[count.index].id
  }

  # Add more configuration options as needed
}

resource "oci_core_boot_volume" "boot_volume" {
  count               = var.instance_count
  compartment_id      = var.compartment_ocid
  display_name        = "my-boot-volume-${count.index}"
  size_in_gbs         = 100
  availability_domain = element(var.availability_domains, count.index)
}

resource "oci_core_block_volume" "additional_block_volume" {
  count                = var.instance_count
  compartment_id       = var.compartment_ocid
  display_name         = "my-additional-block-volume-${count.index}"
  size_in_gbs          = var.additional_block_volume_size
  availability_domain  = element(var.availability_domains, count.index)
}

# Add other resources as required
