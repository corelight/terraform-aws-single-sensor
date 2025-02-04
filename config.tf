module "config" {
  count  = var.custom_sensor_user_data == "" ? 1 : 0
  source = "github.com/corelight/terraform-config-sensor?ref=v0.3.0"

  fleet_community_string           = var.fleet_community_string
  sensor_license                   = file(var.license_key_file_path)
  sensor_management_interface_name = "eth1"
  sensor_monitoring_interface_name = "eth0"

  fleet_token          = var.fleet_config.token
  fleet_url            = var.fleet_config.url
  fleet_server_sslname = var.fleet_config.server_ssl_name
  fleet_http_proxy     = var.fleet_config.http_proxy
  fleet_https_proxy    = var.fleet_config.https_proxy
  fleet_no_proxy       = var.fleet_config.no_proxy

  enrichment_enabled       = var.cloud_enrichment_config.bucket_name != "" && var.cloud_enrichment_config.bucket_region != ""
  enrichment_bucket_name   = var.cloud_enrichment_config.bucket_name
  enrichment_bucket_region = var.cloud_enrichment_config.bucket_region
}