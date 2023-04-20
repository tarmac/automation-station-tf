# resource "aws_wafv2_web_acl_association" "waf-alb" {
#   resource_arn = var.lb_arn  #check resource LB when is created
#   web_acl_arn  = aws_wafv2_web_acl.common_rule_set_regional.arn
# }
