# Policy 03 — encryption at rest is mandatory on every encryption-capable resource.
#
# RBI / PCI-DSS / SOC 2 baseline. Foundation Plan §11.2.
# Catches the most common omissions: RDS, EBS, S3 server-side encryption,
# OpenSearch, EFS.

package main

import rego.v1

# ---------- RDS ----------
deny contains msg if {
	some rc in resources_of_type("aws_db_instance")
	not after(rc).storage_encrypted
	msg := sprintf(
		"[encryption_required] %v.%v storage_encrypted must be true (Foundation Plan §11.2)",
		[rc.type, rc.name],
	)
}

deny contains msg if {
	some rc in resources_of_type("aws_rds_cluster")
	not after(rc).storage_encrypted
	msg := sprintf(
		"[encryption_required] %v.%v storage_encrypted must be true",
		[rc.type, rc.name],
	)
}

# ---------- EBS ----------
deny contains msg if {
	some rc in resources_of_type("aws_ebs_volume")
	not after(rc).encrypted
	msg := sprintf(
		"[encryption_required] %v.%v encrypted must be true",
		[rc.type, rc.name],
	)
}

# ---------- S3 server-side encryption ----------
deny contains msg if {
	some rc in resources_of_type("aws_s3_bucket_server_side_encryption_configuration")
	not has_sse_rule(after(rc))
	msg := sprintf(
		"[encryption_required] %v.%v must declare a rule with apply_server_side_encryption_by_default",
		[rc.type, rc.name],
	)
}

has_sse_rule(a) if {
	some rule in a.rule
	some default_block in rule.apply_server_side_encryption_by_default
	default_block.sse_algorithm != ""
}

# ---------- OpenSearch ----------
deny contains msg if {
	some rc in resources_of_type("aws_opensearch_domain")
	not opensearch_encryption_enabled(after(rc))
	msg := sprintf(
		"[encryption_required] %v.%v encrypt_at_rest.enabled must be true",
		[rc.type, rc.name],
	)
}

opensearch_encryption_enabled(a) if {
	some block in a.encrypt_at_rest
	block.enabled == true
}

# ---------- EFS ----------
deny contains msg if {
	some rc in resources_of_type("aws_efs_file_system")
	not after(rc).encrypted
	msg := sprintf(
		"[encryption_required] %v.%v encrypted must be true",
		[rc.type, rc.name],
	)
}
