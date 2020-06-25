### Optional Permissions
You may or may not want people to be able to list tags and/or list all available repositories within an account.
* List Image Tags - `ecr:ListImages` - `/v2/imageName/tags/list`
* List Repositories - `ecr:DescribeRepositories` - `/v2/_catalog`
  * NOTE: List Repositories only works for the account in which the proxy service is running.

### Cross-Account Access

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "Allow proxy to pull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789876:role/ecr_proxy"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages"
      ]
    }
  ]
}
```
