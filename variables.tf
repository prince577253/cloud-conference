variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "node_count" {
  description = "Number of nodes to provision"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}
