resource "null_resource" "remote" {
connection {
       type = "ssh"
       user = "ec2-user"
       private_key = file("/home/ec2-user/.ssh/id_rsa")
       host  = aws_instance/flask-instance.public_ip
}

provisioner "remote-exec" {
        inline = [
	               "sudo yum update"
		       "sudo yum install python3-venv",
		       "mkdir helloworld"
		       "cd  helloworld"
		       "python3 -m venv venv"
		       "source venv/bin/activate"
		       "pip install Flask"
		       ]
	       }

provisioner "file" {
   source      = "/home/ec2-user/terraform-cource/flask/app.py"
   destination = "/home/ec2-user/helloworld"
}

provisioner "remote-exec" {
        inline =  [
	              "pip install gunicorn"
		  ]
	  }

 provisioner "file" {
    source      = "/home/ec2-user/terraform-cource/flask/helloworld.servicessource"
    destination = "/home/ec2-user/helloworld.services"
} 

provisioner "remote-exec" {
         inline = [
	              "sudo mv /home/ec2-user/helloworld.services/etc/systemd/system/helloworld.service",
		      "sudo systemctl restart sshd.service",
		      "sudo systemctl enable helloworld",
		      "sudo systemctl start  helloworld",
		      ]
	      }
	      
provisioner "remote-exec" {
       inline = [
                      "sudo amazon-linux-extras install nginx1",
		      "chmod  710 /home/ec2-user",
		      "sudo systemctl enable nginx",
		      "sudo systemctl start nginx",
		      ]
	      } 
	      
provisioner "file" {
   source      = "/home/ec2-user/terraform-cource/flask/helloworld.conf"
   destination = "/home/ec2-user/helloworld.conf"
}

provisioner "remote-exec" {
        inline = [
	             "sudo mv /home/ec2-user/helloworld.conf/etc/systemd/system/helloworld.conf",
		     "sudo systemctl restart nginx",
		     ]
	     }
     }

