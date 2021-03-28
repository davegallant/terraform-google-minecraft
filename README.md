# terraform-google-minecraft

![terraform](https://github.com/davegallant/terraform-google-minecraft/workflows/terraform/badge.svg)

This spins up a [Minecraft](https://www.minecraft.net/) server that is composed of:

- a static ip
- a google compute instance
- persistent disk

## Requirements

- [Google Cloud account](https://console.cloud.google.com/getting-started)
- [Docker](https://www.docker.com/get-started)

## Costs

If this server is always running, it will cost ~$15CAD/month.

[GCP Free Tier](https://cloud.google.com/free) includes $300 in credit for ~~12 months~~ 90 days.

## Deployment

This server is configured and managed by [Terraform](https://www.terraform.io).

```shell
# If you do not have terraform and gcloud cli installed,
# enter an environment that has all dependencies (docker is required)
./env.sh # (optional)

# Ensure that you are authenticated to GCP
gcloud auth application-default login

# The initialization requires an existing storage bucket
# To create one, read the following:
# https://cloud.google.com/storage/docs/creating-buckets
export BUCKET='my-existing-bucket'
terraform init -backend-config "bucket=$BUCKET"

# Apply all of the resources
terraform apply -var-file example.tfvars
```

## Snapshots

By default, a daily incremental snapshot is scheduled. This can be disabled in the variables. The max retention of each snapshot defaults to 30 days.

## Additional Notes

- By default, this uses a `n1-highcpu-2` [preemptible vm instance](https://cloud.google.com/compute/docs/instances/preemptible) for cost savings. This means that the minecraft server could restart at any time (roughly every 24h), resulting in a couple minutes of downtime. This can also lead to a couple minutes of data loss depending on when game data was last written to disk. The `preemptible` flag and `machine_type` can be modified in the terraform [variables](./variables.tf). For pricing, see: https://cloud.google.com/compute/vm-instance-pricing
- An instance group manager is used so that preemptible vm instances can be restarted
