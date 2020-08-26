# Google and Google Cloud netblock ranges
data "google_netblock_ip_ranges" "google" {
  range_type = "google-netblocks"
}

data "google_netblock_ip_ranges" "google_cloud" {
  range_type = "cloud-netblocks"
}

# Cloud Armor Security Policies
resource "google_compute_security_policy" "google" {
  project = var.project

  name        = "google-policy"
  description = ""

  # Reject all traffic that hasn't been whitelisted.
  rule {
    action   = "deny(403)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default rule, higher priority overrides it"
  }

  # Split and whitelist the netblocks
  dynamic "rule" {
    for_each = chunklist(data.google_netblock_ip_ranges.google.cidr_blocks, 10)

    content {
      action   = "allow"
      priority = rule.key + 1

      match {
        versioned_expr = "SRC_IPS_V1"

        config {
          src_ip_ranges = rule.value
        }
      }
      description = "Deny access to IPs in [${join(", ", rule.value)}]"
    }
  }
}

resource "google_compute_security_policy" "google_cloud" {
  project     = var.project
  name        = "google-cloud-policy"
  description = ""

  # Reject all traffic that hasn't been whitelisted.
  rule {
    action   = "deny(403)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default rule, higher priority overrides it"
  }

  # Split and whitelist the netblocks
  dynamic "rule" {
    for_each = chunklist(data.google_netblock_ip_ranges.google_cloud.cidr_blocks, 10)

    content {
      action   = "allow"
      priority = rule.key + 1

      match {
        versioned_expr = "SRC_IPS_V1"

        config {
          src_ip_ranges = rule.value
        }
      }
      description = "Deny access to IPs in [${join(", ", rule.value)}]"
    }
  }
}
