# Policy 02 — no public S3 buckets, ever.
#
# Three vectors a bucket becomes public:
#   * Bucket policy with Principal "*" and no Condition restricting access
#   * Public-access-block missing or weakened
#   * Bucket ACL set to public-read or public-read-write
#
# Foundation Plan §11.2 — fintech baseline forbids all three.

package main

import rego.v1

deny contains msg if {
	some rc in resources_of_type("aws_s3_bucket_public_access_block")
	not all_blocks_enabled(after(rc))
	msg := sprintf(
		"[no_public_s3] %v.%v must set block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets all to true (Foundation Plan §11.2)",
		[rc.type, rc.name],
	)
}

all_blocks_enabled(a) if {
	a.block_public_acls == true
	a.block_public_policy == true
	a.ignore_public_acls == true
	a.restrict_public_buckets == true
}

deny contains msg if {
	some rc in resources_of_type("aws_s3_bucket_acl")
	after(rc).acl in {"public-read", "public-read-write"}
	msg := sprintf(
		"[no_public_s3] %v.%v ACL is %q — public ACLs are forbidden (Foundation Plan §11.2)",
		[rc.type, rc.name, after(rc).acl],
	)
}

# Belt-and-braces: every aws_s3_bucket SHOULD have a paired public_access_block.
# We can't see "missing" resources from a plan, but we can flag a bucket that
# has an explicit `acl` of "public-*" set in legacy form.
deny contains msg if {
	some rc in resources_of_type("aws_s3_bucket")
	acl := after(rc).acl
	acl in {"public-read", "public-read-write"}
	msg := sprintf(
		"[no_public_s3] %v.%v sets legacy acl=%q on aws_s3_bucket — use a private bucket with a paired aws_s3_bucket_public_access_block (Foundation Plan §11.2)",
		[rc.type, rc.name, acl],
	)
}
