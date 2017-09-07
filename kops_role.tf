# setup aws provider for dev account
provider "aws" {
  alias = "sub_account"
  region = "${var.bootstrap-aws-default-region}"
  access_key = "${var.sub_account_access_key}"
  secret_key = "${var.sub_account_secret_key}"
}

resource "aws_iam_policy" "external_kops_user_policy" {
    provider = "aws.sub_account"
    name = "ExternalKopsPolicy"
    path = "/"
    policy = <<EOF
    {
    	"Version": "2012-10-17",
    	"Statement": [{
    			"Effect": "Allow",
    			"Action": [
    				"ec2:AcceptVpcPeeringConnection",
    				"ec2:AllocateAddress",
    				"ec2:AssignPrivateIpAddresses",
    				"ec2:AssociateAddress",
    				"ec2:AssociateDhcpOptions",
    				"ec2:AssociateRouteTable",
    				"ec2:AttachClassicLinkVpc",
    				"ec2:AttachInternetGateway",
    				"ec2:AttachNetworkInterface",
    				"ec2:AttachVpnGateway",
    				"ec2:AuthorizeSecurityGroupEgress",
    				"ec2:AuthorizeSecurityGroupIngress",
    				"ec2:CreateCustomerGateway",
    				"ec2:CreateDhcpOptions",
    				"ec2:CreateFlowLogs",
    				"ec2:CreateInternetGateway",
    				"ec2:CreateNatGateway",
    				"ec2:CreateNetworkAcl",
    				"ec2:CreateNetworkAcl",
    				"ec2:CreateNetworkAclEntry",
    				"ec2:CreateNetworkInterface",
    				"ec2:CreateRoute",
    				"ec2:CreateRouteTable",
    				"ec2:CreateSecurityGroup",
    				"ec2:CreateSubnet",
    				"ec2:CreateTags",
    				"ec2:CreateVpc",
    				"ec2:CreateVpcEndpoint",
    				"ec2:CreateVpcPeeringConnection",
    				"ec2:CreateVpnConnection",
    				"ec2:CreateVpnConnectionRoute",
    				"ec2:CreateVpnGateway",
    				"ec2:DeleteCustomerGateway",
    				"ec2:DeleteDhcpOptions",
    				"ec2:DeleteFlowLogs",
    				"ec2:DeleteInternetGateway",
    				"ec2:DeleteNatGateway",
    				"ec2:DeleteNetworkAcl",
    				"ec2:DeleteNetworkAclEntry",
    				"ec2:DeleteNetworkInterface",
    				"ec2:DeleteRoute",
    				"ec2:DeleteRouteTable",
    				"ec2:DeleteSecurityGroup",
    				"ec2:DeleteSubnet",
    				"ec2:DeleteTags",
    				"ec2:DeleteVpc",
    				"ec2:DeleteVpcEndpoints",
    				"ec2:DeleteVpcPeeringConnection",
    				"ec2:DeleteVpnConnection",
    				"ec2:DeleteVpnConnectionRoute",
    				"ec2:DeleteVpnGateway",
    				"ec2:DescribeAddresses",
    				"ec2:DescribeAvailabilityZones",
    				"ec2:DescribeClassicLinkInstances",
    				"ec2:DescribeCustomerGateways",
    				"ec2:DescribeDhcpOptions",
    				"ec2:DescribeFlowLogs",
    				"ec2:DescribeInstances",
    				"ec2:DescribeInternetGateways",
    				"ec2:DescribeKeyPairs",
    				"ec2:DescribeMovingAddresses",
    				"ec2:DescribeNatGateways",
    				"ec2:DescribeNetworkAcls",
    				"ec2:DescribeNetworkInterfaceAttribute",
    				"ec2:DescribeNetworkInterfaces",
    				"ec2:DescribePrefixLists",
    				"ec2:DescribeRouteTables",
    				"ec2:DescribeSecurityGroups",
    				"ec2:DescribeSubnets",
    				"ec2:DescribeTags",
    				"ec2:DescribeVpcAttribute",
    				"ec2:DescribeVpcClassicLink",
    				"ec2:DescribeVpcEndpoints",
    				"ec2:DescribeVpcEndpointServices",
    				"ec2:DescribeVpcPeeringConnections",
    				"ec2:DescribeVpcs",
    				"ec2:DescribeVpnConnections",
    				"ec2:DescribeVpnGateways",
    				"ec2:DetachClassicLinkVpc",
    				"ec2:DetachInternetGateway",
    				"ec2:DetachNetworkInterface",
    				"ec2:DetachVpnGateway",
    				"ec2:DisableVgwRoutePropagation",
    				"ec2:DisableVpcClassicLink",
    				"ec2:DisassociateAddress",
    				"ec2:DisassociateRouteTable",
    				"ec2:EnableVgwRoutePropagation",
    				"ec2:EnableVpcClassicLink",
    				"ec2:ModifyNetworkInterfaceAttribute",
    				"ec2:ModifySubnetAttribute",
    				"ec2:ModifyVpcAttribute",
    				"ec2:ModifyVpcEndpoint",
    				"ec2:MoveAddressToVpc",
    				"ec2:RejectVpcPeeringConnection",
    				"ec2:ReleaseAddress",
    				"ec2:ReplaceNetworkAclAssociation",
    				"ec2:ReplaceNetworkAclEntry",
    				"ec2:ReplaceRoute",
    				"ec2:ReplaceRouteTableAssociation",
    				"ec2:ResetNetworkInterfaceAttribute",
    				"ec2:RestoreAddressToClassic",
    				"ec2:RevokeSecurityGroupEgress",
    				"ec2:RevokeSecurityGroupIngress",
    				"ec2:UnassignPrivateIpAddresses"
    			],
    			"Resource": "*"
    		},
    		{
    			"Effect": "Allow",
    			"Action": "s3:*",
    			"Resource": "*"
    		},
    		{
    			"Effect": "Allow",
    			"Action": "iam:*",
    			"Resource": "*"
    		}, {
    			"Action": "ec2:*",
    			"Effect": "Allow",
    			"Resource": "*"
    		},
    		{
    			"Effect": "Allow",
    			"Action": "elasticloadbalancing:*",
    			"Resource": "*"
    		},
    		{
    			"Effect": "Allow",
    			"Action": "cloudwatch:*",
    			"Resource": "*"
    		},
    		{
    			"Effect": "Allow",
    			"Action": "autoscaling:*",
    			"Resource": "*"
    		}
    	]
    }
EOF
}

# in sub account create a role which can be assumed by main account
resource "aws_iam_role" "external_kops_role" {
    provider = "aws.sub_account"
    name = "ExternalKopsRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.main_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_policy_attachment" "external_kops_user_policy_attachment_to_external_kops_role" {
    provider = "aws.sub_account"
    name = "external_kops_user_policy_attachment"
    roles = ["${aws_iam_role.external_kops_role.name}"]
    policy_arn = "${aws_iam_policy.external_kops_user_policy.arn}"
}
