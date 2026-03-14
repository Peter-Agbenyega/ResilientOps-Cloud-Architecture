# CREATING IAM POLICY DOCUMENT FOR EC2 ASSUME ROLE
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# CREATING IAM ROLE FOR EC2 INSTANCE
resource "aws_iam_role" "ec2_iam_role" {
  name               = "${local.merged_tags["project"]}-${local.merged_tags["application"]}-${local.merged_tags["environment"]}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = merge(local.merged_tags, {
    Name = "${local.merged_tags["project"]}-${local.merged_tags["application"]}-${local.merged_tags["environment"]}-ec2-role"
  })
}

# ATTACHING MANAGED POLICY TO IAM ROLE
resource "aws_iam_role_policy_attachment" "ec2_ssm_managed_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CREATING IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "${local.merged_tags["project"]}-${local.merged_tags["application"]}-${local.merged_tags["environment"]}-ec2-instance-profile"
  role = aws_iam_role.ec2_iam_role.name

  tags = merge(local.merged_tags, {
    Name = "${local.merged_tags["project"]}-${local.merged_tags["application"]}-${local.merged_tags["environment"]}-ec2-instance-profile"
  })
}
