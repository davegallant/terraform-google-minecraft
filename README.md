# terraform-google-minecraft

This spins up a minecraft server using a static ip, a google compute instance and persistent disk.

## Requirements

- [google cloud account](https://console.cloud.google.com/getting-started)
- [gcloud cli](https://cloud.google.com/sdk)
- [terraform](https://www.terraform.io/intro/index.html)


## Use

```shell
gcloud auth application-default login
terraform init
terraform apply -var-file example.tfvars
```

## Notes

- By default, this uses a [preemptible vm instance](https://cloud.google.com/compute/docs/instances/preemptible) for cost savings. This means that the minecraft server could restart at any time, and there may potentially be a few minutes of data loss when this occurs. This can be disabled in the terraform variables. For pricing, see: https://cloud.google.com/compute/vm-instance-pricing
- An instance group manager is used so that preemptible vm instances can be restarted
- Because instance group managers are used, every time a plan is run, a random name will given to the instance group manager and vm instance template. This is to prevent a `resourceInUseByAnotherResource` that mentions `Error deleting instance template: googleapi: Error 400: The instance_template resource is already being used`

## Todo

- Add optional snapshot strategy
