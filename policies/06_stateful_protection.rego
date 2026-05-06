# Policy 06 — stateful resources in prod must have deletion protection.
#
# Catches accidental destroy of databases, load balancers, KMS keys.
# Foundation Plan §11.2.

package main

import rego.v1

# RDS instances
deny contains msg if {
	some rc in resources_of_type("aws_db_instance")
	is_prod(rc)
	not after(rc).deletion_protection
	msg := sprintf(
		"[stateful_protection] %v.%v in prod must set deletion_protection = true (Foundation Plan §11.2)",
		[rc.type, rc.name],
	)
}

deny contains msg if {
	some rc in resources_of_type("aws_rds_cluster")
	is_prod(rc)
	not after(rc).deletion_protection
	msg := sprintf(
		"[stateful_protection] %v.%v in prod must set deletion_protection = true",
		[rc.type, rc.name],
	)
}

# Load balancers (data persists in target groups, but accidental delete still hurts)
deny contains msg if {
	some rc in resources_of_type("aws_lb")
	is_prod(rc)
	not after(rc).enable_deletion_protection
	msg := sprintf(
		"[stateful_protection] %v.%v in prod must set enable_deletion_protection = true",
		[rc.type, rc.name],
	)
}

# KMS keys — deletion window must be >= 7 days; using the default of 30 is fine,
# but explicit shorter windows are forbidden in prod.
deny contains msg if {
	some rc in resources_of_type("aws_kms_key")
	is_prod(rc)
	win := after(rc).deletion_window_in_days
	win < 7
	msg := sprintf(
		"[stateful_protection] %v.%v deletion_window_in_days=%v in prod (must be >= 7)",
		[rc.type, rc.name, win],
	)
}

# DynamoDB tables in prod must enable point-in-time recovery
deny contains msg if {
	some rc in resources_of_type("aws_dynamodb_table")
	is_prod(rc)
	not pitr_enabled(after(rc))
	msg := sprintf(
		"[stateful_protection] %v.%v in prod must enable point_in_time_recovery",
		[rc.type, rc.name],
	)
}

pitr_enabled(a) if {
	some block in a.point_in_time_recovery
	block.enabled == true
}
