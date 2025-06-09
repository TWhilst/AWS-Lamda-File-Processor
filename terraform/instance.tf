resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Project1_public.id
  vpc_security_group_ids = [aws_security_group.Project1_sg_ssh.id, aws_security_group.Project1_sg_http.id, aws_security_group.Project1_sg_jenkins.id]
  key_name               = aws_key_pair.Project1_key.key_name
  user_data              = file("~/.vscode/Java-E-Commerce-Backend/deploy.sh")

  tags = {
    Name = "java-jenkins-server"
  }
}

resource "aws_instance" "ansible_server" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.Project1_public.id
  vpc_security_group_ids = [aws_security_group.Project1_sg_ssh.id, aws_security_group.Project1_sg_http.id, aws_security_group.Project1_sg_jenkins.id, aws_security_group.Project1_sg_sq.id]
  key_name               = aws_key_pair.Project1_key.key_name
  user_data              = file("~/.vscode/Java-E-Commerce-Backend/script.sh")

  tags = {
    Name = "java-ansible-server"
  }
}