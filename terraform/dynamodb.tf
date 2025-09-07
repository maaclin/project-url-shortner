
resource "aws_dynamodb_table" "url" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
    ignore_changes = all
  }

  tags = { Name = "${local.name}-db-table" }

}