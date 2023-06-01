terraform {
  backend "s3" {
    bucket = var bucket_name
    key = var key
    region = var region
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

resource "aws_iam_role" "eks_iam_role" {
    name = "esanders-dothw-eks-iam-role"

    path = "/"

    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17"
        "Statement": [
            {
                "Effect": "Allow",
                "Principal":{
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role        = aws_iam_role.eks-iam-role 
}

resource "aws_eks_cluster" "esanders_DOTHW_eks" {
    name = "esanders_DOTHW_cluster"
    role_arn = aws_iam_role.eks-iam-role.arn

    vpc_config {
      subnet_ids = [var.var.subnet_id_1, var.var.subnet_id_2]
    }

    depends_on = [ 
        aws_iam_role.eks_iam_role
     ]
}

resource "aws_iam_role" "eks-fargate" {
    name = "eks-fargate-esanders-DOTHW"

    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks-fargate-pods.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
    role       = aws_iam_role.eks-fargate.name 
  
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy-fargate" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks-fargate.name 
  
}

resource "aws_eks_fargate_profile" "esanders_DOTHW_eks_serverless" {
    cluster_name           = aws_eks_cluster.esanders_DOTHW_eks.name
    fargate_profile_name   = "esanders_DOTHW_serverless_eks"
    pod_execution_role_arn = aws_iam_role.eks-fargate.arn
    subnetsubnet_ids       = [var.private_subnet_id_1]

    selector {
      namespace = "default"
    }
}