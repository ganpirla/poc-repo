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



=====
  


resource "oci_core_volume" "block_volume" {
  count             = length(oci_core_instance.compute_instance)
  availability_domain = oci_core_subnet.subnet[count.index].availability_domain
  compartment_id    = var.compartment_ocid
  display_name      = "BlockVolume-${oci_core_instance.compute_instance[count.index].display_name}"
  size_in_gbs       = var.block_volume_size
}

resource "oci_core_volume_attachment" "block_volume_attachment" {
  count                = length(oci_core_instance.compute_instance)
  availability_domain  = oci_core_subnet.subnet[count.index].availability_domain
  instance_id          = oci_core_instance.compute_instance[count.index].id
  volume_id            = oci_core_volume.block_volume[count.index].id
}

resource "oci_core_instance" "compute_instance" {
  count             = length(var.instance_display_names)
  compartment_id    = var.compartment_ocid
  display_name      = var.instance_display_names[count.index]
  shape             = var.shape
  subnet_id         = oci_core_subnet.subnet[count.index].id
  image_id          = "<IMAGE_OCID>"

  defined_tags = {
    "<TAG_NAMESPACE>.<TAG_KEY>" = "<TAG_VALUE>"
  }

  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = true
  }

  network_interface {
    subnet_id = oci_core_subnet.subnet[count.index].id
    vnic_id   = oci_core_vnic.vnic[count.index].id
  }

  metadata = {
    ssh_authorized_keys = "<SSH_PUBLIC_KEY>"
  }

  lifecycle {
    create_before_destroy = true
  }

  # Other instance configurations...
}
