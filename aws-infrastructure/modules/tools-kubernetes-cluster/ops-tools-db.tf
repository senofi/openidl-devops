resource "aws_db_instance" "ops_tools_db" {
  identifier             = "ops-tools-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "13.7"
  username               = "postgres"
  password               = var.ops_tools_db_password
  db_subnet_group_name   = aws_db_subnet_group.ops_tools.name
  vpc_security_group_ids = [module.eks.cluster_security_group_id, module.eks.cluster_primary_security_group_id, aws_security_group.ops_tools_db-sg.id]
#  parameter_group_name   = aws_db_parameter_group.ops_tools_db
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = local.tags
}

resource "aws_db_subnet_group" "ops_tools" {
  name       = "ops-tools"
  subnet_ids = module.vpc.public_subnets

  tags = local.tags
}

resource "aws_security_group" "ops_tools_db-sg" {
  name = "ops_tools_db-sg"
  ingress {
    from_port = 5432
    protocol  = "tcp"
    to_port   = 5432
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }
  egress {
    from_port = "0"
    protocol  = "all"
    to_port   = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = module.vpc.vpc_id
}
