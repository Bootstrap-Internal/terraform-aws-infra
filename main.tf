terraform {
  backend "s3" {
    bucket         = "s3-rnt-core-tf-state-390844737705"  
    key            = "rnt/datahub/api/terraform.tfstate"      
    region         = "us-east-1"                           
    encrypt        = true                            
    dynamodb_table = "dynamodb-rnt-core-tf-state-lock"          
  }
}
