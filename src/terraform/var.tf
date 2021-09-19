variable "ami" {
  default = "ami-08e6b682a466887dd"
  description = "ami for t4g.large"
}

variable "instance_type" {
  default = "t4g.large"
}

variable "os_type" {
  default = "arm"
}

variable "os" {
  default = "ubuntu"
}

variable "availability_zone" {
  default = "us-east-2c"
}

variable "project" {
  default = "dacha"
}

variable "owner" {
  default = "timofei.korolev@jetbrains.com"
}

variable "user" {
  default = "ubuntu"
}

