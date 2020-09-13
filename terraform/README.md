# Initial setup

- manually create bucket specified in s3 terraform backend to workaround chicken/egg problem

# Setup required to run terraform commands

export tokens to env:
  - `DIGITALOCEAN_ACCESS_TOKEN`: do personal access token
  - `AWS_ACCESS_KEY_ID`: do spaces access key id for tf state backend
  - `AWS_SECRET_ACCESS_KEY`: do spaces secret access key for tf state backend
  - `SPACES_ACCESS_KEY_ID`: do spaces access key id for managing do spaces
  - `SPACES_SECRET_ACCESS_KEY`: do spaces secret access key for managing do spaces

install kubectl within 1 minor version of k8s cluster version:
https://kubernetes.io/docs/tasks/tools/install-kubectl/

install terraform to exact version used by terraform code
