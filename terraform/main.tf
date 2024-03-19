provider "aws" {
  region     = var.aws_region   
  access_key = secrets.YOUR_ACCESS_KEY
  secret_key = secrets.YOUR_SECRET_KEY   
}
resource "aws_security_group" "grafana_sg" {
  name        = "grafana_sg"
  description = "Security Group for the Grafana instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "grafana" {
  ami           = var.instance_ami_grafana # Ubuntu 20.04 LTS
  instance_type = var.instance_type_grafana
  key_name      = var.pem_key
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apt-transport-https
              sudo apt-get install -y software-properties-common wget
              wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
              echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
              sudo apt-get update
              sudo apt-get install -y grafana
              sudo systemctl start grafana-server
              sudo systemctl enable grafana-server
              
              EOF

  tags = {
    Name = "Grafana"
  }
}
resource "aws_security_group" "nextjs_app_sg" {
  name        = "nextjs_app_sg"
  description = "Security Group for the Next.js app instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nextjs_app" {
  ami           = var.instance_ami_app # Ubuntu 20.04 LTS
  instance_type = var.instance_type_app
  key_name      = var.pem_key
  vpc_security_group_ids = [aws_security_group.nextjs_app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              
              # Prometheus installation
              
              wget https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz
              tar xvf prometheus-2.30.3.linux-amd64.tar.gz
              sudo mv prometheus-2.30.3.linux-amd64/prometheus /usr/local/bin/
              sudo mv prometheus-2.30.3.linux-amd64/promtool /usr/local/bin/
              sudo mkdir -p /etc/prometheus
              sudo mv prometheus-2.30.3.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
              sudo rm -rf prometheus-2.30.3.linux-amd64 prometheus-2.30.3.linux-amd64.tar.gz
              
              # Prometheus service
              
              sudo bash -c 'cat << EOF > /etc/systemd/system/prometheus.service
              [Unit]
              Description=Prometheus
              Wants=network-online.target
              After=network-online.target

              [Service]
              User=root
              Group=root
              Type=simple
              ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml

              [Install]
              WantedBy=multi-user.target
              EOF'
              sudo systemctl daemon-reload
              sudo systemctl start prometheus
              sudo systemctl enable prometheus

              # Node exporter installation
              
              wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
              tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
              sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin

              # Node_Exporter service
              
              sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
              [Unit]
              Description=Node Exporter
              After=network.target

              [Service]
              User=node_exporter
              ExecStart=/usr/local/bin/node_exporter

              [Install]
              WantedBy=default.target
              EOF'
              sudo useradd -rs /bin/false node_exporter
              sudo systemctl daemon-reload
              sudo systemctl start node_exporter
              sudo systemctl enable node_exporter
              
              # Nextjs installation
              
              sudo apt-get update -y
              curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
              sudo apt-get install -y nodejs
              sudo npm install -g npm@latest
              mkdir /home/ubuntu/Wetter_App
              sudo chown -R $USER:$USER /home/ubuntu/Wetter_App
              git clone https://github.com/RaupeCHR/Wetter_App.git /home/ubuntu/Wetter_App
              cd /home/ubuntu/Wetter_App
              npm install
             
              EOF

  tags = {
    Name = "Nextjs_App"
  }
}