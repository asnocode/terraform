output "storage_container"{
    value = azurerm_storage_container.container
}


output "container_name"{
    value = azurerm_storage_container.container.name
}
