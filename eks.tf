resource "aws_eks_cluster" "eks" {
    name     = "${var.app_name}-eks-cluster"
    role_arn = aws_iam_role.eks_role.arn
    vpc_config {
            subnet_ids = concat(
            [for subnet in values(aws_subnet.public_subnets) : subnet.id],
            [for subnet in values(aws_subnet.private_subnets) : subnet.id]
        )
    }
}

resource "aws_eks_node_group" "eks_nodes" {
    node_group_name = "${var.app_name}-eks-node-group"
    cluster_name = aws_eks_cluster.eks.name
    subnet_ids = concat(
        [for subnet in values(aws_subnet.public_subnets) : subnet.id],
        [for subnet in values(aws_subnet.private_subnets) : subnet.id]
    )
    node_role_arn = aws_iam_role.eks_node_role.arn
    instance_types = var.eks_node_group_instance_types
    scaling_config {
        desired_size = var.eks_node_group_scaling_config["desired_size"]
        max_size     = var.eks_node_group_scaling_config["max_size"]
        min_size     = var.eks_node_group_scaling_config["min_size"]
    }
}