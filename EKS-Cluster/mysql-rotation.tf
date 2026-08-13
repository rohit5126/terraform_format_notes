resource "aws_serverlessapplicationrepository_cloudformation_stack" "mysql_rotation" {
  name           = "SecretsManagerRDSMySQLRotationSingleUser"
  application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSMySQLRotationSingleUser"
  capabilities   = ["CAPABILITY_IAM", "CAPABILITY_RESOURCE_POLICY"]

  parameters = {
    functionName        = "bankapp-mysql-rotation"
    endpoint             = "https://secretsmanager.eu-north-1.amazonaws.com"
    vpcSecurityGroupIds  = aws_security_group.mysql_rotation_lambda.id
    vpcSubnetIds         = join(",", module.vpc.private_subnets)   # match your actual VPC module output
  }
}

resource "aws_security_group" "mysql_rotation_lambda" {
  name   = "mysql-rotation-lambda-sg"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # needed to reach the Secrets Manager API
  }
}

resource "aws_secretsmanager_secret_rotation" "mysql" {
  secret_id           = aws_secretsmanager_secret.mysql.id
  rotation_lambda_arn = aws_serverlessapplicationrepository_cloudformation_stack.mysql_rotation.outputs["RotationLambdaARN"]

  rotation_rules {
    automatically_after_days = 30
  }
}
