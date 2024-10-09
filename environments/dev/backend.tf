terraform {
  backend "s3" {
    bucket         = "s3-rnt-core-tf-state-390844737705"  
    key            = "terraform.tfstate"  
    region         = "us-east-1"                  
    #dynamodb_table = "terraform-lock-table"        Optional for state locking
    encrypt        = true                         
  }
}