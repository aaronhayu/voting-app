provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "voting_app_cluster" {
  name     = "voting-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "voting-app-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
}

resource "aws_db_instance" "postgres" {
  engine         = "postgres"
  engine_version = "13.7"
  instance_class = "db.t3.micro"
  db_name           = "votingdb"
  username       = "dbuser"
  password       = "dbpassword"
  multi_az       = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}