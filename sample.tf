
provider "oci" {
  # Configure the OCI provider
  # ...
}

resource "oci_network_load_balancer" "internal_lb" {
  # Create the internal load balancer
  # ...
  
  subnet_id              = oci_core_subnet.private_subnet.id
  is_private             = true
  is_preserve_source     = true
}

resource "oci_network_load_balancer_listener" "listener" {
  # Create the load balancer listener
  # ...
  
  load_balancer_id = oci_network_load_balancer.internal_lb.id
  name             = "listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.backend_set.name
  port             = 80
  protocol         = "HTTP"
}

resource "oci_network_load_balancer_backend_set" "backend_set" {
  # Create the load balancer backend set
  # ...
  
  load_balancer_id = oci_network_load_balancer.internal_lb.id
  name             = "backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_network_load_balancer_backend" "backend1" {
  # Create backend 1
  # ...
  
  backend_set_name = oci_network_load_balancer_backend_set.backend_set.name
  instance_id      = oci_core_instance.compute_instance1.id
  port             = 80
  weight           = 1
}

resource "oci_network_load_balancer_backend" "backend2" {
  # Create backend 2
  # ...
  
  backend_set_name = oci_network_load_balancer_backend_set.backend_set.name
  instance_id      = oci_core_instance.compute_instance2.id
  port             = 80
  weight           = 1
}

# Define your compute instances and subnet here
resource "oci_core_instance" "compute_instance1" {
  # ...
}

resource "oci_core_instance" "compute_instance2" {
  # ...
}

resource "oci_core_subnet" "private_subnet" {
  # ...
}
