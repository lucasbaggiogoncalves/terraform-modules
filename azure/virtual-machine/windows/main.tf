resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_prefix}nic${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vmw" {
  name                = "${var.resource_prefix}vmw${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.vm_user
  admin_password      = var.vm_password

  tags = var.tags

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  boot_diagnostics {}

  availability_set_id = var.availability_set_id
}

resource "azurerm_managed_disk" "disk" {
  count                = length(var.disk_sizes)
  name                 = "${var.resource_prefix}dsk${var.resource_suffix}${format("%03d", count.index + 1)}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = element(var.disk_storage_account_type, count.index)
  create_option        = "Empty"
  disk_size_gb         = element(var.disk_sizes, count.index)

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  count                = length(var.disk_sizes)
  managed_disk_id      = element(azurerm_managed_disk.disk.*.id, count.index)
  virtual_machine_id   = azurerm_windows_virtual_machine.vmw.id
  lun                  = count.index
  caching              = "ReadWrite"
}