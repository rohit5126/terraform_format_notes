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
    host     = "mysql-state-0.mysql.newbankapp.svc.cluster.local"
    port     = 3306
    username = "root"
    password = random_password.mysql_password.result
    dbname   = "bankapp"
  })
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
