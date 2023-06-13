variable "name" {
  type = string
}
variable "machine-type" {
  type = string
}
variable "zone" {
  type = string
}
variable "boot-image" {
  type = string
}
variable "vpc-uri" {
  type = string
}
variable "subnet-uri" {
  type = string
}
variable "service-account-email" {
  type = string
}
variable "service-account-scope" {
  type = list(string)
}