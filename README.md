# cloud-armor-google-netblocks

Self updating Cloud Armor policies using Terraform and Cloud Build.
The policies will whitelist [Google](https://support.google.com/a/answer/60764?hl=en) and [Google Cloud](https://www.gstatic.com/ipranges/cloud.json) netblocks.


## Pre-Reqs

- Google Cloud Project
- Billing enabled
- Terraform service account with at least the following permissions:
    - ...
    - ...
- Google Cloud Storage

## Installation
1. Clone this repo to your account
1. [Connect](https://console.cloud.google.com/cloud-build/triggers/connect) your repo to your project
1. Change the `project`, `github_owner`, and `github_repo` variables in the [configuration file](./environments/dev/environment.tfvar)

### References

- https://cloud.google.com/solutions/managing-infrastructure-as-code
