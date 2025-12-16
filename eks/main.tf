provider "aws" {
    region = "eu-north-1"
}

#Default vpc and subnets
data "aws_vpc" "default_vpc" {
    default = true #since we are using default vpc, we have to make it true
}

#this will bring all the subnets related to our default vpc we define above, can do this using "filter"
data "aws_subnets" "default_subnets" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default_vpc.id]
    }
}

#Role and policy attachment
resource "aws_iam_role" "tf_eks_cluster_role" {
  name = "eks_cluster_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

#Cluster
resource "aws_eks_cluster" "tf_eks_cluster" {
  name = "my-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.tf_eks_cluster_role.arn
  version  = "1.33"

  vpc_config {
    subnet_ids = data.aws_subnets.default_subnets.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

#Node gropu

#Role and policy attachment for node group
resource "aws_iam_role" "tf_node_group_role" {
  name = "tf_node_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ]
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            },
            
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_node_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tf_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_node_WorkeNode_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tf_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_node_Container_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tf_node_group_role.name
}

#Node group
resource "aws_eks_node_group" "tf_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "node_group"
  node_role_arn   = aws_iam_role.tf_node_group_role.arn
  subnet_ids      = data.aws_subnets.default_subnets.ids 
  instance_types = [ "m7i-flex.large" ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_node_CNI_Policy,
    aws_iam_role_policy_attachment.cluster_node_WorkeNode_Policy,
    aws_iam_role_policy_attachment.cluster_node_Container_Policy,
  ]
}