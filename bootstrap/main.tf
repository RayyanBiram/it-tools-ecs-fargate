resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "build_push" {
  name = "github-actions-build-push-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:RayyanBiram/it-tools-ecs-fargate:environment:build-push"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "build_push" {
  name = "build-push-policy"
  role = aws_iam_role.build_push.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ECRAuth",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
      {
        "Sid" : "ECRPushPull",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource" : "arn:aws:ecr:eu-west-2:187949931624:repository/it-tools-ecs-fargate"
      },
      {
        "Sid" : "ECSDeploy",
        "Effect" : "Allow",
        "Action" : [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PassExecutionRole",
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "arn:aws:iam::187949931624:role/ecs-task-execution-role"
      },
    ]
  })
}

resource "aws_iam_role" "infra" {
  name = "terraform-infra-deploy-destroy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:RayyanBiram/it-tools-ecs-fargate:environment:infra"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "iam" {
  name = "iam-access-policy"
  role = aws_iam_role.infra.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "IAMAccess",
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:TagRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ],
        "Resource" : "arn:aws:iam::187949931624:role/ecs-task-execution-role"
    }]
  })
}

resource "aws_iam_role_policy" "s3" {
  name = "s3-access-policy"
  role = aws_iam_role.infra.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "S3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::it-tools-ecs-fargate-terraform-state",
          "arn:aws:s3:::it-tools-ecs-fargate-terraform-state/*"
        ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "infra_vpc" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "infra_ecs" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "infra_ecr" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "infra_elb" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_role_policy_attachment" "infra_route53" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "infra_acm" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}