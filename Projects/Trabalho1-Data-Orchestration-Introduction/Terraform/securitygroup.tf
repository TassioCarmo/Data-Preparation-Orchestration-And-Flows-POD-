# Criando um grupo de segurança
resource "azurerm_network_security_group" "securitygroup-aulas" {
  name                = "${local.tags["securitygroup"]}"
  location            = "${local.tags["azureregion"]}"
  resource_group_name = "${local.tags["resourcegroup"]}"
  
  depends_on = [azurerm_resource_group.resourcegroup_aulas,
    azurerm_virtual_network.network-aulas
  ]
  tags = var.tags
}

# Criando regra de segurança para conexão de entrada
resource "azurerm_network_security_rule" "inboundrole-aulas" {
  name                        = "regraportassh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = ["${local.tags["ippessoal"]}"]
  destination_address_prefix  = "*"
  resource_group_name         = "${local.tags["resourcegroup"]}"
  network_security_group_name = azurerm_network_security_group.securitygroup-aulas.name
  
  depends_on = [azurerm_resource_group.resourcegroup_aulas,
    azurerm_virtual_network.network-aulas,
    azurerm_network_security_group.securitygroup-aulas
  ]
}

# Criando regra de segurança para conexão de saida
resource "azurerm_network_security_rule" "outboundrole-aulas" {
  name                        = "regraportahttp"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix     = "VirtualNetwork"
  destination_address_prefixes  = ["${local.tags["ippessoal"]}"]
  resource_group_name         = "${local.tags["resourcegroup"]}"
  network_security_group_name = azurerm_network_security_group.securitygroup-aulas.name
  
  depends_on = [azurerm_resource_group.resourcegroup_aulas,
    azurerm_virtual_network.network-aulas,
    azurerm_network_security_group.securitygroup-aulas
  ]
}