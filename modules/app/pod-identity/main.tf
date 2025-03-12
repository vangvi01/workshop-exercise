resource "aws_iam_openid_connect_provider" "web_server_cluster_identity_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_certificate.certificates.0.sha1_fingerprint]
  url             = data.aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer
}


resource "aws_iam_role" "messagehash_store_role" {
  name = "${var.cluster_name}-MessagehashStoreRole"
  assume_role_policy = templatefile("${path.module}/AssumeRolePolicy.json", {
    OIDC_ARN        = aws_iam_openid_connect_provider.web_server_cluster_identity_provider.arn,
    OIDC_ID         = replace(data.aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer, "https://", "")
    NAMESPACE       = var.namespace,
    SERVICE_ACCOUNT = var.service_account_name
  })
}

# resource "aws_iam_policy" "messagehash_store_policy" {
#   name        = "MessagehashStoreAccessPolicy"
#   description = "Policy granting full access to MessagehashStore DynamoDB table"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "MessagehashStoreTableAccess"
#         Effect = "Allow"
#         Action = [
#           "dynamodb:BatchGetItem",
#           "dynamodb:BatchWriteItem",
#           "dynamodb:ConditionCheckItem",
#           "dynamodb:DeleteItem",
#           "dynamodb:DescribeTable",
#           "dynamodb:GetItem",
#           "dynamodb:GetRecords",
#           "dynamodb:PutItem",
#           "dynamodb:Query",
#           "dynamodb:Scan",
#           "dynamodb:UpdateItem"
#         ]
#         Resource = [
#           "arn:aws:dynamodb:*:*:table/MessagehashStore",
#           "arn:aws:dynamodb:*:*:table/MessagehashStore/index/*"
#         ]
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "messagehash_store_policy_attachment" {
  role       = aws_iam_role.messagehash_store_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess" ## Granting full access to dynamoDB since this is a workshop
  #policy_arn = aws_iam_policy.messagehash_store_policy.arn

}

