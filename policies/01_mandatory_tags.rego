# Policy 01 — every taggable AWS resource MUST carry the Devotica mandatory tag set.
#
# Foundation Plan §15.2 specifies six required tags. Auditors check this in the
# console; we enforce it at PR time so the violation never reaches AWS.

package main

import rego.v1

mandatory_tags := {
	"Environment",
	"Project",
	"Owner",
	"CostCenter",
	"ManagedBy",
	"Repo",
}

# A resource type is "taggable" if it has the tags attribute. Maintaining a
# negative list (resources that DON'T support tags) would be a moving target,
# so we instead enumerate the high-traffic taggable types we care about.
taggable_types := {
	"aws_vpc",
	"aws_subnet",
	"aws_internet_gateway",
	"aws_nat_gateway",
	"aws_route_table",
	"aws_security_group",
	"aws_s3_bucket",
	"aws_kms_key",
	"aws_iam_role",
	"aws_iam_policy",
	"aws_cloudwatch_log_group",
	"aws_db_instance",
	"aws_rds_cluster",
	"aws_eks_cluster",
	"aws_lb",
	"aws_lb_target_group",
	"aws_ecs_cluster",
	"aws_ecs_service",
	"aws_dynamodb_table",
	"aws_cloudfront_distribution",
	"aws_wafv2_web_acl",
}

deny contains msg if {
	some rc in planned_resources
	rc.type in taggable_types
	some required in mandatory_tags
	not tags_of(rc)[required]
	msg := sprintf(
		"[mandatory_tags] %v.%v is missing required tag %q (Foundation Plan §15.2)",
		[rc.type, rc.name, required],
	)
}
