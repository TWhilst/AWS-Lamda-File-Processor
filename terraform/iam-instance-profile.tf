data "aws_iam_role" "ec2_manage" {
  name = "k8s"
}

resource "aws_iam_instance_profile" "Admin_access" {
  name = "Ec2-manage-s3-profile"
  role = data.aws_iam_role.ec2_manage.name
}