
resource "aws_instance" "jenkins" {

  ami                    = ""
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.jenkins.key_name
  subnet_id              = aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]



  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("/Users/manohar/Desktop/Study/DevOps/ClassNotes/terrafrom-dev-stack/keypairs/jenkins-keypair.pem")
  #   host        = aws_instance.jenkins.public_ip
  # }
  # provisioner "remote-exec" {
  #   # Installing Git into the system.  Here in this inline list,
  #   # multiple commands can be passed which 
  #   # are required to run in the remote system.
  #   inline = [
  #     "#!/bin/bash",
  #     "sudo apt update",
  #     "echo 'Y' | sudo apt install openjdk-17-jre-headless",
  #     "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
  #     "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
  #     "sudo apt-get update",
  #     "echo 'Y' | sudo apt-get install jenkins",
  #   ]
  # }

  tags = {
    Name = "manu-jenkins-instance"
  }
}
