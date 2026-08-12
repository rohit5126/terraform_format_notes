terraform {
  backend "s3" {
    bucket       = "rohit-state-bucket-5126"
    key          = "terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    
    # Enable S3-native state locking
    use_lockfile = true 
  }
}
