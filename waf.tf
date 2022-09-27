module "waf" {
  source = "umotif-public/waf-webaclv2/aws" #https://github.com/umotif-public/terraform-aws-waf-webaclv2
  version = "~> 3.0.0"

  name_prefix = "test-waf-setup"
  alb_arn     = aws_lb.lb.arn

  scope = "REGIONAL"

  create_alb_association = true

  allow_default_action = true # set to allow if not specified

  visibility_config = {
    metric_name = "test-waf-setup-waf-main-metrics"
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
        {
      name     = "AWSManagedRulesLinuxRuleSet-rule-3"
      priority = "3"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesLinuxRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesUnixRuleSet-rule-4"
      priority = "4"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesUnixRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesSQLiRuleSet-rule-5"
      priority = "5"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesSQLiRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
  ]

  tags = {
    "Name" = "devsecops-waf"
    "Env"  = "test"
  }
}