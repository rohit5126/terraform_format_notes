output "s3_bucket-id" {
  value = aws_s3_bucket.my_s3_bucket.id
}

output "s3_bucket-domain-name" {
    value = aws_s3_bucket.my_s3_bucket.bucket_domain_name
  
}
