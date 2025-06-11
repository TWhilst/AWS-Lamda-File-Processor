/// Key Pair
resource "aws_key_pair" "Project1_key" {
  key_name   = "toche-key1"
  public_key = file("~/.ssh/toche-key1.pub") # Path to your public key
}