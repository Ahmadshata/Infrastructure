variable "cluster-name" {
  type = string
}
variable "master-cidr" {
  type = string
}
variable "cluster-zone" {
  type = string
}
variable "vpc-uri" {
  type = string
}
variable "subnet-uri" {
  type = string
}
variable "authorized-cidr-1" {
  type = string
}
variable "authorized-network-name-1" {
  type = string
}
variable "authorized-cidr-2" {
  type = string
}
variable "authorized-network-name-2" {
  type = string
}
variable "node-pool-count" {
  type = number
}
variable "node-pool-machine_type" {
  type = string
}