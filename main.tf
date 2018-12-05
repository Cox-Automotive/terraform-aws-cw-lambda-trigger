resource "aws_cloudwatch_event_rule" "schedule_based" {
  count               = "${var.mode == "schedule_based" ? 1 : 0}"
  name                = "cw-rule-schedule_${var.function_name}"
  description         = "Schedule based CloudWatch rule for ${var.function_name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_rule" "pattern_based" {
  count         = "${var.mode == "pattern_based" ? 1 : 0}"
  name          = "cw-rule-pattern_${var.function_name}"
  description   = "Pattern based CloudWatch rule for ${var.function_name}"
  event_pattern = "${var.event_pattern}"
}

data "null_data_source" "name" {
  inputs = {
    pattern_based  = "${element(concat(aws_cloudwatch_event_rule.pattern_based.*.name, list("")), 0)}"
    schedule_based = "${element(concat(aws_cloudwatch_event_rule.schedule_based.*.name, list("")), 0)}"
  }
}

data "null_data_source" "arn" {
  inputs = {
    pattern_based  = "${element(concat(aws_cloudwatch_event_rule.pattern_based.*.arn, list("")), 0)}"
    schedule_based = "${element(concat(aws_cloudwatch_event_rule.schedule_based.*.arn, list("")), 0)}"
  }
}

data "null_data_source" "rule" {
  inputs = {
    name = "${coalesce(data.null_data_source.name.outputs["pattern_based"], data.null_data_source.name.outputs["schedule_based"])}"
    arn  = "${coalesce(data.null_data_source.arn.outputs["pattern_based"], data.null_data_source.arn.outputs["schedule_based"])}"
  }
}

resource "aws_clouwatch_event_target" "scope" {
  target_id = "cw-target_${var.function_name}"
  rule      = "${data.null_data_source.rule.outputs["name"]}"
  arn       = "${var.function_arn}"
}

resource "aws_lambda_permission" "trigger" {
  statement_id  = "cw-trigger_${var.function_name}"
  action        = "${var.lambda_action}"
  function_name = "${var.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${data.null_data_source.rule.outputs["arn"]}"
}
