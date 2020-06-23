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
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
```
