resource "aws_sqs_queue" "terraform_queue" {
  name                      = "demo-queue"
  visibility_timeout_seconds = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  
  
  tags = {
    name = "demo-sqs"
  }
}