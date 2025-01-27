#cloud-config

write_files:
  - owner: root:root
    path: /etc/corelight/corelightctl.yaml
    permissions: '0644'
    content: |
      sensor:
        api:
          password: ${community_string}
        license_key: ${license}
        management_interface:
          name: ${mgmt_int}
        monitoring_interface:
          name: ${mon_int}
          wait: false
%{ if health_port != "" ~}
        health_check:
          port: ${health_port}
%{ endif ~}
        kubernetes:
          allow_ports:
%{ for probe in probe_ranges ~}
            - protocol: tcp
              port: ${health_port}
              net: ${probe}
%{ endfor ~}
%{ if fleet_token != "" && fleet_url != "" ~}
        pairing:
          token: ${fleet_token}
          url: ${fleet_url}
          server_sslname: ${fleet_server_sslname}
%{ if fleet_http_proxy != "" ~}
          http_proxy: ${fleet_http_proxy}
%{ endif ~}
%{ if fleet_https_proxy != "" ~}
          https_proxy: ${fleet_https_proxy}
%{ endif ~}
%{ if fleet_no_proxy != "" ~}
          no_proxy: ${fleet_no_proxy}
%{ endif ~}
%{ endif ~}
runcmd:
  - corelightctl sensor deploy -v
%{ if enrichment_enabled ~}
  - |
    echo '{
        "cloud_enrichment.enable": "true",
        "cloud_enrichment.cloud_provider": "aws",
        "cloud_enrichment.bucket_name": "${bucket_name}",
        "cloud_enrichment.bucket_location": "${bucket_region}"
    }' | corelightctl sensor cfg put
%{endif ~}
  - |
    echo '{
        "cloud_vpc_flow.enable": "true",
        "cloud_vpc_flow.start_date": "${start_date}",
        "cloud_vpc_flow.monitored_vpcs": "${monitored_vpcs}",
        "cloud_vpc_flow.monitored_regions": "${monitored_regions}",
        "cloud_vpc_flow.s3_bucket_prefix": "${s3_bucket_prefix}",
        "cloud_vpc_flow.log_level": "${log_level}",
        "cloud_vpc_flow.concurrency": "${concurrency}",
        "cloud_vpc_flow.frequency": "${frequency}",
        "cloud_vpc_flow.broker_event_batch_size": "${broker_event_batch_size}",
        "cloud_vpc_flow.broker_publish_frequency": "${broker_publish_frequency}",
        "cloud_vpc_flow.broker_url": "${broker_url}",
        "cloud_vpc_flow.broker_topic": "${broker_topic}",
        "cloud_vpc_flow.enable_zeek_copy_service": "${enable_zeek_copy_service}"
    }' | corelightctl sensor cfg put
  - /usr/local/bin/kubectl rollout restart deployment -n corelight-sensor sensor-core
