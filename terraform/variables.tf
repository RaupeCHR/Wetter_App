variable aws_region {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-central-1"
}


variable project_name {
  description = "The name of the project"
  type        = string
  default     = "abschlussprojekt"
}

variable github_owner {
  description = "GitHub repository owner"
  type        = string
  default     = "RaupeCHR"
}  

variable github_repo {
  description = "GitHub repository name"
  type        = string
  default     = "Wetter_App"
}

variable github_branch {
  description = "GitHub repository branch"
  type        = string
  default     = "main"
}

variable instance_ami_app {
  description = "instance ami app"
  type        = string
  default     = "ami-04f9a173520f395dd"
}
variable instance_ami_grafana {
  description = "instance ami grafana"
  type        = string
  default     = "ami-04f9a173520f395dd"
}   

variable instance_type_app {
  description = "instance type app"
  type        = string
  default     = "t2.small"
}
variable instance_type_grafana {
  description = "instance type grafana"
  type        = string
  default     = "t2.micro"
}

variable "access_key" {
  description = "AWS access key"

}
variable "secret_key" {
  description = "AWS secret key"
  
} 


variable pem_key {
  description = "ssh key name"
  type        = string
  default     = "sshkey_privat"
}

# Path: terraform/main.tf   