data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-config/init.tpl", {
      community_string  = var.fleet_community_string
      license           = file(var.license_key_file_path)
      mgmt_int          = "eth1"
      mon_int           = "eth0"
      health_port       = "41080"
      monitored_vpcs    = join(",", var.vpc_flow_config.monitored_vpcs)
      monitored_regions = join(",", var.vpc_flow_config.monitored_regions)
      start_date        = var.vpc_flow_config.start_date
      s3_bucket_prefix  = var.vpc_flow_config.s3_bucket_prefix
      frequency         = var.vpc_flow_config.frequency

      fleet_token          = var.fleet_config.token
      fleet_url            = var.fleet_config.url
      fleet_server_sslname = var.fleet_config.server_ssl_name
      fleet_http_proxy     = var.fleet_config.http_proxy
      fleet_https_proxy    = var.fleet_config.https_proxy
      fleet_no_proxy       = var.fleet_config.no_proxy

      enrichment_enabled = var.cloud_enrichment_config.bucket_name != "" && var.cloud_enrichment_config.bucket_region != ""
      bucket_name        = var.cloud_enrichment_config.bucket_name
      bucket_region      = var.cloud_enrichment_config.bucket_region

    })
    filename = "sensor-build.yaml"
  }
}
