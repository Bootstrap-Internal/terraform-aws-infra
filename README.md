├── environments/
│   ├── dev/
│   │   ├── terraform_dev.tfvars
│   │   └── backend.tf
│   ├── prod/
│   │   ├── terraform_prod.tfvars
│   │   └── backend.tf
│   └── qa/
│   │   ├── terraform_stagging.tfvars
│       └── backend.tf
├── modules/
│   ├── api_gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── output.tf
├── provider.tf
├── versions.tf
└── README.md
