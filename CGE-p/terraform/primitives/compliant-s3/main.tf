/* 

Creation of a compliant S3 bucket + encryption
hardcoded version

Controls to integrate : 
NIST 800-53 framework : Security and Privacy Controls for Information Systems and Organizations

Terraform parameters for AWS :https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest

*/

// SC-28 PROTECTION OF INFORMATION AT REST WITH AES 256

resource "aws_s3_bucket" "evidence" { // bucket with tags
    bucket_prefix = "grc-evidence-prod-" //generate unique name to avoid collision

    tags = { //provider default tags, it stamps these on every resource
        Project          = "cge-p-portolio"
        Environment      = "production"
        ManagedBy        = "terraform"
        ComplianceScope  = "nist-800-53"
    } 
}

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
    bucket = aws_s3_bucket.evidence.id

    rule { // configuration block, sse = server side
       apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
       }
    }
}

// CM-6  CONFIGURATION SETTINGS : immutable audit trail
resource "aws_s3_bucket_versioning" "evidence" {
    bucket = aws_s3_bucket.evidence.id
    versioning_configuration {
        status = "Enabled" // every object version is preserved thanks to this option
    }
}

// AC-3 ACCESS ENFORCEMENT: no public access for resources, configuration does not allow it
resource "aws_s3_bucket_public_access_block" "evidence" {
    bucket                = aws_s3_bucket.evidence.id 
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

// AU-6 AUDIT RECORD REVIEW, ANALYSIS, AND REPORTING 
resource "aws_s3_bucket" "logs" { 
    bucket = "grc-evidence-prod-logs"
   // tags = local.compliance_tags
}
// AU-3 CONTENT OF AUDIT RECORDS (who accessed the data)
resource "aws_s3_bucket_logging" "evidence" {
    bucket        = aws_s3_bucket.evidence.id
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "s3-access/" 
} 


