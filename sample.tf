resource "oci_network_load_balancer" "internal_lb" {
  compartment_id   = var.compartment_ocid
  display_name     = "InternalLB"
  shape_name       = "100Mbps"
  is_private       = true

  subnet_id        = oci_core_subnet.subnet[0].id

  backend {
    subnet_id   = oci_core_subnet.subnet[0].id
    ip_address  = oci_core_instance.compute_instance[0].private_ip
  }

  backend {
    subnet_id   = oci_core_subnet.subnet[1].id
    ip_address  = oci_core_instance.compute_instance[1].private_ip
  }

  listener {
    name         = "HTTPListener"
    port         = 80
    backend_port = 8080
    protocol     = "HTTP"
  }

  listener {
    name         = "HTTPSListener"
    port         = 443
    backend_port = 8443
    protocol     = "HTTPS"
    ssl_configuration {
      certificate_name = "SSL Certificate"
      verify_depth     = 1
      verify_peer_certificate = true
    }
  }
}
