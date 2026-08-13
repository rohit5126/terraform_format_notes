resource "random_password" "mysql_password" {
  length  = 12
  special = false
}

resource "aws_secretsmanager_secret" "mysql" {
  name = "bankapp/mysql"
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    engine   = "mysql"
    host     = "a28643631bb424079ab601e44d734fd8-9a26cb8303cd62eb.elb.eu-north-1.amazonaws.com"
    port     = 3306
    username = "root"
    password = random_password.mysql_password.result
    dbname   = "bankapp"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}



resource "random_password" "grafana_admin" {
  length  = 10
  special = false
}

resource "aws_secretsmanager_secret" "grafana" {
  name = "bankapp/grafana-admin"
}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id     = aws_secretsmanager_secret.grafana.id
  secret_string = random_password.grafana_admin.result
}
