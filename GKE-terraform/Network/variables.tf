variable "vpc-name" {
  type = string
}
variable "subnet-name" {
  type = string
}
variable "private-google-access" {
  type = bool
}
variable "subnet-cidr" {
  type = string
}
variable "subnet-region" {
  type = string
}
variable "secondary-ip-range-1-name" {
  type = string
}
variable "secondary-ip-range-1-cidr" {
  type = string
}
variable "secondary-ip-range-2-name" {
  type = string
}
variable "secondary-ip-range-2-cidr" {
  type = string
}
variable "router-name" {
  type = string
}
variable "nat-name" {
  type = string
}
variable "nat-ip-allocation" {
  type = string
}
variable "source-subnet-ranges" {
  type = string
}
variable "bgp-keepalive" {
  type = number
}