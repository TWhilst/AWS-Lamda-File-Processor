resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.Project1_sg_ssh.id, aws_security_group.Project1_sg_jenkins.id]
  key_name               = aws_key_pair.Project1_key.key_name
  user_data              = file("~/.vscode/AWS-Lamda-File-Processor/jenkins.sh")

  tags = {
    Name = "function-jenkins-server"
  }
}

resource "aws_instance" "slave_server" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.medium"
  subnet_id              = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.Project1_sg_ssh.id, aws_security_group.Project1_sg_http.id]
  key_name               = aws_key_pair.Project1_key.key_name
  user_data              = file("~/.vscode/AWS-Lamda-File-Processor/slave.sh")
  iam_instance_profile  = aws_iam_instance_profile.Admin_access.name

  tags = {
    Name = "function-slave-server"
  }
}