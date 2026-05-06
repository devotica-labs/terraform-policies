# Policy 05 — no security group ingress from 0.0.0.0/0 (or ::/0) on prod
# resources without an explicit waiver tag.
#
# An ALB or CloudFront fronting public traffic is a legitimate exception, so
# the policy honours `DevoticaWaiver=public-edge` on the SG resource.
#
# Foundation Plan §11.2.

package main

import rego.v1

# aws_security_group with embedded ingress blocks
deny contains msg if {
	some rc in resources_of_type("aws_security_group")
	is_prod(rc)
	some rule in after(rc).ingress
	some cidr in rule.cidr_blocks
	is_open_cidr(cidr)
	not has_waiver(rc)
	msg := sprintf(
		"[no_open_sg_ingress] %v.%v has ingress from %v in prod — add DevoticaWaiver=public-edge if this is an ALB/CloudFront origin (Foundation Plan §11.2)",
		[rc.type, rc.name, cidr],
	)
}

# Standalone aws_security_group_rule
deny contains msg if {
	some rc in resources_of_type("aws_security_group_rule")
	after(rc).type == "ingress"
	is_prod_rule(rc)
	some cidr in after(rc).cidr_blocks
	is_open_cidr(cidr)
	not has_waiver(rc)
	msg := sprintf(
		"[no_open_sg_ingress] %v.%v ingress from %v in prod",
		[rc.type, rc.name, cidr],
	)
}

# Modern aws_vpc_security_group_ingress_rule
deny contains msg if {
	some rc in resources_of_type("aws_vpc_security_group_ingress_rule")
	is_prod_rule(rc)
	cidr := after(rc).cidr_ipv4
	is_open_cidr(cidr)
	not has_waiver(rc)
	msg := sprintf(
		"[no_open_sg_ingress] %v.%v ingress from %v in prod",
		[rc.type, rc.name, cidr],
	)
}

# A resource is "prod" when its tags indicate so. We treat absence of an
# Environment tag as non-prod (the mandatory_tags policy will catch missing tags
# separately, so we don't double-report here).
is_prod(rc) if tags_of(rc).Environment == "prod"

is_prod_rule(rc) if tags_of(rc).Environment == "prod"
