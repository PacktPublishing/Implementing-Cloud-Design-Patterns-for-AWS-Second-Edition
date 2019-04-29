resource "aws_iam_user" "cloudpatterns" {
  name = "loadbalancer"
}

resource "aws_iam_group_membership" "admin" {
  name = "tf-admin-group-membership"

  users = [
    "${aws_iam_user.cloudpatterns.name}",
  ]

  group = "${aws_iam_group.group.name}"
}

resource "aws_iam_group" "group" {
  name = "cloudpatterngroup"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = "${aws_iam_group.group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
