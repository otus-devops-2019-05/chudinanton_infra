terraform {
  backend "gcs" {
    bucket = "storage-bucket-states"
    prefix = "terraform/states/stage"
  }
}
