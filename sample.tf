
resource "oci_core_virtual_network" "private_network" {
  cidr_block = "10.0.0.0/16"
}

resource "oci_core_subnet" "subnet" {
  cidr_block        = "10.0.0.0/24"
  vcn_id            = oci_core_virtual_network.private_network.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_instance" "instance1" {
  availability_domain = "<availability_domain>"
  compartment_id     = "<compartment_id>"
  shape              = "VM.Standard2.1"
  subnet_id          = oci_core_subnet.subnet.id
  # ...other instance configuration...
}

resource "oci_core_instance" "instance2" {
  availability_domain = "<availability_domain>"
  compartment_id     = "<compartment_id>"
  shape              = "VM.Standard2.1"
  subnet_id          = oci_core_subnet.subnet.id
  # ...other instance configuration...
}

resource "oci_load_balancer_load_balancer" "ilb" {
  compartment_id = "<compartment_id>"
  display_name   = "internal-lb"
  is_private     = true
  subnet_ids     = [oci_core_subnet.subnet.id]

  backend_sets {
    name = "backend-set"

    policy = "ROUND_ROBIN"

    backend {
      ip_address = oci_core_instance.instance1.private_ip
      port       = 80
    }

    backend {
      ip_address = oci_core_instance.instance2.private_ip
      port       = 80
    }
  }
}

resource "oci_load_balancer_listener" "listener" {
  load_balancer_id = oci_load_balancer_load_balancer.ilb.id
  name             = "listener"
  port             = 80
  protocol         = "HTTP"

  default_backend_set_name = oci_load_balancer_load_balancer.ilb.backend_sets[0].name
}

resource "oci_load_balancer_health_check" "health_check" {
  load_balancer_id = oci_load_balancer_load_balancer.ilb.id
  name             = "health-check"
  protocol         = "HTTP"
  url_path         = "/health"
  port             = 80
  retries          = 3
  timeout_in_millis = 3000
  interval_in_millis = 10000
  response_body_regex = "^OK$"
}
