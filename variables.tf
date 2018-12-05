#-------------------------------------------------------------------------------
# REQUIRED VARIABLES
#-------------------------------------------------------------------------------
variable "function_name" {
  type        = "string"
  description = "(Required) The name of the Lambda function on which an action will be taken."
}

variable "function_arn" {
  type        = "string"
  description = "(Required) The ARN of the Lambda function on which an action will be taken."
}

variable "mode" {
  type        = "string"
  description = "(Required) Must be 'schedule_based' if providing a schedule_expression or 'pattern_based' if providing an event_pattern."
}

#-------------------------------------------------------------------------------
# OPTIONAL VARIABLES
#-------------------------------------------------------------------------------
variable "lambda_action" {
  type        = "string"
  description = "(Optional) The action that will be taken on the Lambda function. Defaults to 'lambda:InvokeFunction'."
  default     = "lambda:InvokeFunction"
}

variable "schedule_expression" {
  type        = "string"
  description = "(Required if mode is `schedule_based`) The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes)."
  default     = ""
}

variable "event_pattern" {
  type        = "string"
  description = "(Required if mode is `pattern_based`) JSON object describing the CloudWatch event pattern."
  default     = ""
}
