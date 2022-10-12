packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "mlapp" {
  image  = "python:3.8-slim"
  commit = true
  changes = [
      "USER www-data",
      "WORKDIR /app",
      "EXPOSE 5000",
      "LABEL version=1.0",
      "ONBUILD RUN python -m pip install -r requirements.txt",
      "CMD [\"python\", \"app.py\"]",
    ]
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.mlapp"
  ]
  post-processors {
  post-processor "docker-tag" {
      repository = "12345.dkr.ecr.us-east-1.amazonaws.com/packer"
      tags = ["0.7"]
  }
  post-processor "docker-push" {
      ecr_login = true
      aws_access_key = "YOUR KEY HERE"
      aws_secret_key = "YOUR SECRET KEY HERE"
      login_server = "12345.dkr.ecr.us-east-1.amazonaws.com"
  }
}

}
