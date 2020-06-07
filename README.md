# terraform-google-minecraft

This spins up a minecraft server using a static ip, a google compute instance and persistent disk.

## Requirements

- [google cloud account](https://console.cloud.google.com/getting-started)

and either:
- [bash](https://www.gnu.org/software/bash/)
- [docker](https://docs.docker.com/get-docker/)

or:


- [gcloud cli](https://cloud.google.com/sdk)
- [terraform](https://www.terraform.io/intro/index.html)


## Use

```shell
# This will build the environment in docker and enter it
# This is not necessary if all tools are installed externally on host
./env.sh

gcloud auth application-default login
# The initialization prompts for a storage bucket that must be manually created and specified
# https://cloud.google.com/storage/docs/creating-buckets
terraform init
terraform apply -var-file example.tfvars
```

## Notes

- By default, this uses a `n1-highcpu-2` [preemptible vm instance](https://cloud.google.com/compute/docs/instances/preemptible) for cost savings. This means that the minecraft server could restart at any time, resulting in a couple minutes of downtime. This can also lead to a couple minutes of data loss depending on when game data was last written to disk. The `preemptible` flag and `machine_type` can be modified in the terraform [variables](./variables.tf). For pricing, see: https://cloud.google.com/compute/vm-instance-pricing
- An instance group manager is used so that preemptible vm instances can be restarted
- Because instance group managers are used, every time a plan is run, a random name will given to the instance group manager and vm instance template. This is to prevent a `resourceInUseByAnotherResource` that mentions `Error deleting instance template: googleapi: Error 400: The instance_template resource is already being used`

## Todo

- Add optional snapshot strategy
