# Shared helpers consumed by every policy file in this package.
#
# All Devotica policies operate on a Terraform plan rendered to JSON, i.e. the
# output of `terraform show -json tfplan.binary`. We unwrap that consistently
# here so individual policies stay small and focused.

package main

import rego.v1

# ---------- plan unwrapping ----------

# All resources Terraform plans to create or update. We deliberately ignore
# `delete` actions (you cannot violate a policy by deleting something).
planned_resources contains rc if {
	some rc in input.resource_changes
	some action in rc.change.actions
	action in {"create", "update", "create-before-destroy"}
}

# Filter planned_resources by AWS resource type
resources_of_type(t) := [rc |
	some rc in planned_resources
	rc.type == t
]

# After-state of a single planned resource (the values it WILL have)
after(rc) := rc.change.after

# Tags map on a planned resource (handles both `tags` and `tags_all`).
# Returns {} when neither is set.
tags_of(rc) := t if {
	t := rc.change.after.tags
	t != null
} else := t if {
	t := rc.change.after.tags_all
	t != null
} else := {}

# True if the value is one of the AWS-meaningful "permissive" CIDRs.
is_open_cidr(cidr) if cidr == "0.0.0.0/0"

is_open_cidr(cidr) if cidr == "::/0"
