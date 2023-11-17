# Define the locals
locals {
  settings = {
    "SQL2022" = {
      image_publisher = "MicrosoftSQLServer"
      image_offer     = "sql2022-ws2022"
      image_sku = (var.image_sku == "developer" ? "sqldev-gen2" :
        (var.image_sku == "enterprise" ? "enterprise-gen2" :
      "standard-gen2"))

      image_version = "latest"
    },
    "SQL2019" = {
      image_publisher = "MicrosoftSQLServer"
      image_offer     = "sql2019-ws2019"
      image_sku = (var.image_sku == "developer" ? "sqldev-gen2" :
        (var.image_sku == "enterprise" ? "enterprise-gen2" :
      "standard-gen2"))
      image_version = "latest"
    },
    "SQL2017" = {
      image_publisher = "MicrosoftSQLServer"
      image_offer     = "SQL2017-WS2019"
      image_sku = (var.image_sku == "developer" ? "sqldev-gen2" :
        (var.image_sku == "enterprise" ? "enterprise-gen2" :
      "standard-gen2"))
      image_version = "latest"
    },
    "SQL2016" = {
      image_publisher = "MicrosoftSQLServer"
      image_offer     = "sql2016sp3-ws2019"
      image_sku = (var.image_sku == "developer" ? "sqldev" :
        (var.image_sku == "enterprise" ? "enterprise" :
      "standard"))
      image_version = "latest"
    }
  }

  current_settings = local.settings[var.sql_version]

}
