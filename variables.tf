variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable shared_vpc_enabled {
  description = "Set to true if resource is being built in a shared-vpc"
  default     = true
}

variable shared_vpc_project {
  description = "Shared vpc project name."
  default     = ""
}

variable region {
  description = "Region for cloud resources."
  default     = ""
}

variable network {
  description = "Name of the network to create resources in, should be shared vpc network name if you use shared vpc"
  default     = ""
}

variable subnetwork {
  description = "Name of the subnetwork to create resources in, should be shared vpc subnetwork name if you use shared vpc"
  default     = ""
}


variable lb_name {
  description = "Name for the forwarding rule and prefix for supporting resources."
}

variable backends {
  description = "List of backends, should be a map of key-value pairs for each backend, mush have the 'group' key."
  type        = "list"
}

variable session_affinity {
  description = "The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`."
  default     = "NONE"
}

variable ports {
  description = "List of ports range to forward to backend services. Max is 5."
  type        = "list"
}

variable http_health_check {
  description = "Set to true if health check is type http, otherwise health check is tcp."
  default     = false
}

variable health_port {
  description = "Port to perform health checks on."
}

variable source_tags {
  description = "List of source tags for ingress traffic to internal load balancer."
  type        = "list"
}

variable target_tags {
  description = "List of target tags for egress traffic from internal load balancer."
  type        = "list"
}

variable ip_address {
  description = "IP address of the internal load balancer, if empty one will be assigned. Default is empty."
  default     = ""
}

variable ip_protocol {
  description = "The IP protocol for the backend and frontend forwarding rule. TCP or UDP."
  default     = "TCP"
}
