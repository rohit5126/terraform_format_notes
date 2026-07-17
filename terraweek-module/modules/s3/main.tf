resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "${var.env}-rohit-bucket-5126"
    region = var.region
}