resource "aws_kms_key" "state-key" {
    deletion_window_in_days = 30
    enable_key_rotation = true

}

resource "aws_kms_alias" "state-key" {
    name = "alias/terraform-state-key"
    target_key_id = aws_kms_key.state-key.key_id

}

resource "aws_s3_bucket" "terraform-state" {
    bucket = "rohit-state-bucket-5126"
    force_destroy = false 
    

}

resource "aws_s3_bucket_versioning" "terraform-state" {
    bucket = aws_s3_bucket.terraform-state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state" {
    bucket = aws_s3_bucket.terraform-state.id

    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state-key.arn
        sse_algorithm = "aws:kms"
      }
    }
  
}