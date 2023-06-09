
resource "oci_network_load_balancer" "internal_lb" {
  compartment_id   = var.compartment_ocid
  display_name     = "InternalLB"
  shape_name       = "100Mbps"
  is_private       = true

  subnet_id        = oci_core_subnet.subnet[0].id

  backend {
    subnet_id = oci_core_subnet.subnet[0].id
    ip_address = oci_core_instance.compute_instance[0].private_ip
  }

  backend {
    subnet_id = oci_core_subnet.subnet[1].id
    ip_address = oci_core_instance.compute_instance[1].private_ip
  }
}
