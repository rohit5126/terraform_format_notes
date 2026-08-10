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
    username = "root"
    password = random_password.mysql_password.result
    database = "bankapp"
  })
}


resource "aws_secretsmanager_secret" "duckdns" {
  name = "bankapp/duckdns-token"
}

resource "aws_secretsmanager_secret_version" "duckdns" {
  secret_id     = aws_secretsmanager_secret.duckdns.id
  secret_string = "ecdaa977-9ad9-443f-af09-4397abfbbd3f"
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