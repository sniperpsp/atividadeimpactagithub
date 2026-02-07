resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30
  sqs_managed_sse_enabled    = true

  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  name                    = "${var.project_name}-${var.environment}-dlq"
  sqs_managed_sse_enabled = true

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-dlq" })
}

resource "aws_sqs_queue_redrive_policy" "main" {
  queue_url = aws_sqs_queue.main.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}
