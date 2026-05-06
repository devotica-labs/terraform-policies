# Policy 04 — IAM policies must not use Action="*" or Resource="*" without an
# explicit waiver tag. Catches the single most common over-permissive mistake.
#
# Foundation Plan §11.2 — wildcards forbidden in prod without waiver.

package main

import rego.v1

# Inline policies attached to roles
deny contains msg if {
	some rc in resources_of_type("aws_iam_role_policy")
	policy_doc := json.unmarshal(after(rc).policy)
	some stmt in policy_doc.Statement
	stmt.Effect == "Allow"
	has_wildcard(stmt)
	not has_waiver(rc)
	msg := sprintf(
		"[no_iam_wildcards] %v.%v contains Effect=Allow with wildcard Action or Resource — add tag DevoticaWaiver=<reason> if intentional (Foundation Plan §11.2)",
		[rc.type, rc.name],
	)
}

# Standalone managed policies
deny contains msg if {
	some rc in resources_of_type("aws_iam_policy")
	policy_doc := json.unmarshal(after(rc).policy)
	some stmt in policy_doc.Statement
	stmt.Effect == "Allow"
	has_wildcard(stmt)
	not has_waiver(rc)
	msg := sprintf(
		"[no_iam_wildcards] %v.%v contains Effect=Allow with wildcard Action or Resource",
		[rc.type, rc.name],
	)
}

has_wildcard(stmt) if stmt.Action == "*"

has_wildcard(stmt) if stmt.Resource == "*"

has_wildcard(stmt) if {
	is_array(stmt.Action)
	"*" in stmt.Action
}

has_wildcard(stmt) if {
	is_array(stmt.Resource)
	"*" in stmt.Resource
}

has_waiver(rc) if tags_of(rc).DevoticaWaiver
