provider "oci" {
  tenancy_ocid         = "<TENANCY_OCID>"
  user_ocid            = "<USER_OCID>"
  fingerprint          = "<USER_FINGERPRINT>"
  private_key_path     = "<PRIVATE_KEY_PATH>"
  region               = "<REGION>"
  compartment_ocid     = "<COMPARTMENT_OCID>"
}

resource "oci_core_instance" "backend_node1" {
  compartment_id             = "<COMPARTMENT_OCID>"
  availability_domain        = "<AVAILABILITY_DOMAIN>"
  shape                      = "<SHAPE>"
  source_details {
    source_type              = "image"
    source_id                = "<IMAGE_OCID>"
  }
  create_vnic_details {
    subnet_id                = "<SUBNET_OCID>"
  }
}

resource "oci_core_instance" "backend_node2" {
  compartment_id             = "<COMPARTMENT_OCID>"
  availability_domain        = "<AVAILABILITY_DOMAIN>"
  shape                      = "<SHAPE>"
  source_details {
    source_type              = "image"
    source_id                = "<IMAGE_OCID>"
  }
  create_vnic_details {
    subnet_id                = "<SUBNET_OCID>"
  }
}

resource "oci_load_balancer_backend_set" "example_backend_set" {
  name     = "example-backend-set"
  policy   = "ROUND_ROBIN"

  health_checker {
    protocol           = "HTTP"
    url_path           = "/health"
    port               = 80
    retries            = 3
    return_code        = 200
    timeout_in_millis  = 3000
    interval_in_millis = 10000
  }

  backend {
    ip_address = oci_core_instance.backend_node1.primary_vnic.0.private_ip
    port       = 80
    weight     = 1
  }

  backend {
    ip_address = oci_core_instance.backend_node2.primary_vnic.0.private_ip
    port       = 80
    weight     = 1
  }
}

resource "oci_load_balancer_listener" "example_listener" {
  name               = "example-listener"
  default_backend_set_name = oci_load_balancer_backend_set.example_backend_set.name
  port               = 80
  protocol           = "HTTP"
}

resource "oci_load_balancer_load_balancer" "example_load_balancer" {
  compartment_id         = "<COMPARTMENT_OCID>"
  display_name           = "example-loadbalancer"
  shape_name             = "<LOAD_BALANCER_SHAPE>"
  subnet_ids             = ["<SUBNET_OCID>"]
  is_private             = true

  backend_sets {
    name = oci_load_balancer_backend_set.example_backend_set.name
  }

  listeners {
    name               = oci_load_balancer_listener.example_listener.name
    default_backend_set_name = oci_load_balancer_listener.example_listener.default_backend_set_name
    port               = oci_load_balancer_listener.example_listener.port
    protocol           = oci_load_balancer_listener.example_listener.protocol
  }
}

