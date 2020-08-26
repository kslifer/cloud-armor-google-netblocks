# cloud-armor-google-netblocks

Self updating Cloud Armor policies using Terraform, Terragrunt, Cloud Build, and Cloud Scheduler.
The Cloud Armor Policies created will allow whitelisting of [Google](https://support.google.com/a/answer/60764?hl=en) or [Google Cloud](https://www.gstatic.com/ipranges/cloud.json) netblocks.


## What does this do?

This will create and maintain:
- a Cloud Scheduler job that at 15m intervals will activate... 
- a Cloud Build Trigger (targetting a specific branch) that will...
- perform a `terragrunt apply-all` to...
- update Cloud Armor policies for the `Google` and `Google Cloud` netblocks.

### Branches

Since this is based off of Google's [Managing Infrastructure as Code](https://cloud.google.com/solutions/managing-infrastructure-as-code) article, it uses branch names to determine which directory in the [environments](./environments) folder will be applied.

Pushing to `master` will cause `terragunt plan` to be run across each directory in the [environments](./environments) folder for sanity checking.


## Pre-Reqs

- Google Cloud Project
- Billing enabled
- Terraform service account with at least the following permissions:
    - (create cloud build trigger)
    - (create cloud scheduler job)
    - (create service accounts)
    - (enable APIs)
    - (create cloud Armor policies/rules)
    - (probably more I forgot about but it'll hit me eventually...)
- Google Cloud Storage bucket for Terraform state

## Installation
1. Clone this repo to your account
1. [Connect](https://console.cloud.google.com/cloud-build/triggers/connect) your repo to your project
1. Change `bucket = "rpyell-taos-bucket"` in the org level [terragrunt.hcl](./environments/terragrunt.hcl) file to point to your bucket
1. Change the `project`, `github_owner`, and `github_repo` variables in an [environment configuration file](./environments/dev/environment.tfvar)
1. Commit changes to repo
1. Run `terragrunt apply` 

### References

- https://cloud.google.com/solutions/managing-infrastructure-as-code


### Future
I don't plan on keeping up with this. It was more of an experimental thing because Kevin dared me. If I was going to re-do this I would:
- Use my [Historical Google Netblocks](https://github.com/roscoejp/gcp-netblocks-historical) repo as a starting point
- Change a lot of the tfvars to come from the Cloud Build pipeline itself. This would allow the initial setup process to be:
    - Clone repo to your SCM
    - Create bucket
    - Create Cloud Build Trigger (with bucket ID substitution)
- Have Cloud Build Trigger after a commit to the repo _only_ to remove the need for the Cloud Scheduler. This would  reduce cost a bit since Github actions are free for public repos. It'd also reduce the number of calls to Cloud Build - reducing cost a bit more.
- Remove the [scheduled_build](./modules/scheduled_build) module because it'd be unnecessary
- Get rid of Terragrunt (since at that point it's not necessary because bucket would be defined in the Cloud Build trigger)
