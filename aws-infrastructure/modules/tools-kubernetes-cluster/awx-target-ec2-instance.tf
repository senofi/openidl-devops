resource "aws_instance" "awx_target" {
  ami                         = "ami-097a2df4ac947655f"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.vpc.default_security_group_id, module.eks.cluster_primary_security_group_id, aws_security_group.awx_target_sg.id]
  instance_type               = "t2.micro"
  key_name                    = "awx-target"
  associate_public_ip_address = true
}

resource "aws_security_group" "awx_target_sg" {
  name = "awx-target-sg"
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "tcp"
    to_port   = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = module.vpc.vpc_id
}