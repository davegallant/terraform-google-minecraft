# terraform-google-minecraft

This spins up a minecraft server using a static ip, a google compute instance and persistent disk.

## Requirements

- [google cloud account](https://console.cloud.google.com/getting-started)

and one of the following:
- [nix](https://nixos.org/)
- [docker](https://docs.docker.com/get-docker/)


## Costs

If this server is always running, it will cost ~$15/month.

A [12-month free trial](https://cloud.google.com/free) includes $300 in credit.

## Use

```shell
# If you have nix:
$ nix-shell

# If you do not have nix:
$ ./env.sh

$ gcloud auth application-default login
# The initialization prompts for a storage bucket that must be manually created and specified
# https://cloud.google.com/storage/docs/creating-buckets
$ terraform init
$ terraform apply -var-file example.tfvars
```

## Notes

- By default, this uses a `n1-highcpu-2` [preemptible vm instance](https://cloud.google.com/compute/docs/instances/preemptible) for cost savings. This means that the minecraft server could restart at any time, resulting in a couple minutes of downtime. This can also lead to a couple minutes of data loss depending on when game data was last written to disk. The `preemptible` flag and `machine_type` can be modified in the terraform [variables](./variables.tf). For pricing, see: https://cloud.google.com/compute/vm-instance-pricing
- An instance group manager is used so that preemptible vm instances can be restarted
- Because instance group managers are used, every time terraform does an apply, a random name will given to the instance group manager and vm instance template. This is to prevent a `resourceInUseByAnotherResource` that mentions `Error deleting instance template: googleapi: Error 400: The instance_template resource is already being used`

## Todo

- Add optional snapshot strategy
