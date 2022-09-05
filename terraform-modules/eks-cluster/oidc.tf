locals {
  install_eksctl_cmd = "apt-get update -y; apt-get install -y curl; curl --silent --location 'https://github.com/weaveworks/eksctl/releases/download/v0.110.0/eksctl_Linux_amd64.tar.gz' | tar xz -C /tmp; mv /tmp/eksctl /usr/local/bin"
  create_oidc_cmd = "eksctl utils associate-iam-oidc-provider --region ${var.aws_region} --cluster ${data.aws_eks_cluster.eks.name} --approve"
  cmd = var.install_eksctl == "yes" ? join(";",[local.install_eksctl_cmd,local.create_oidc_cmd]): local.create_oidc_cmd
} 
 
 resource "null_resource" "iam_oidc_provider" {
  provisioner "local-exec" {
    command = local.cmd
  }
} 

data "external" "get_oidc_script" {
  program = ["python", "${path.module}/scripts/get_oidc.py",data.aws_eks_cluster.eks.name]

  
}