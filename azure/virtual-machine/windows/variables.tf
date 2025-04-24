variable "resource_prefix" {
    type    = string
}
variable "resource_suffix" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "subnet_id" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "vm_user" {
  type = string
  sensitive = true
}
variable "vm_password" {
  type = string
  sensitive = true
}
variable "image_publisher" {
  type = string
  default = "MicrosoftWindowsServer"
}
variable "image_offer" {
  type = string
  default = "WindowsServer"
}
variable "image_sku" {
  type = string
}
variable "availability_set_id" {
  type = string
  default = null
}
variable "disk_sizes" {
  type = list(number)
  default = []
}
variable "disk_storage_account_type" {
  type = list(string)
  default = []
}