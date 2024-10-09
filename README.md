<h1>Terraform Infrastructure Repository</h1>

<p>This repository contains Terraform code to provision and manage cloud infrastructure. It is structured to support multiple environments (development, qa, staging, production) and follows a modular approach to organize infrastructure components.</p>

<h2>Directory Layout</h2>

<pre><code>
├── environments           # Environment-specific configuration files
│   ├── dev                # Development environment
│   │   ├── main.tf        # Environment-specific Terraform configuration
│   │   ├── variables.tf   # Environment-specific variables
│   │   └── outputs.tf     # Environment-specific outputs
│   ├── qa                 # qa environment  
│   ├── staging            # Staging environment
│   └── prod               # Production environment
│
├── products               # To define segregation for different product 
├── modules                # Reusable Terraform modules for different infrastructure components
│   ├── vpc                # Module for provisioning a VPC
│   │   ├── vpc.tf         # VPC resource definitions (renamed from main.tf)
│   │   ├── variables.tf   # Input variables for the VPC module
│   │   └── outputs.tf     # Outputs for the VPC module
│   ├── ec2                # Module for provisioning EC2 instances
│   │   ├── ec2.tf         # EC2 resource definitions (renamed from main.tf)
│   │   ├── variables.tf   # Input variables for the EC2 module
│   │   └── outputs.tf     # Outputs for the EC2 module
│   ├── s3                 # Module for provisioning S3 buckets
│   │   ├── s3.tf          # S3 resource definitions (renamed from main.tf)
│   │   ├── variables.tf   # Input variables for the S3 module
│   │   └── outputs.tf     # Outputs for the S3 module
│   └── rds                # Module for provisioning RDS databases
│       ├── rds.tf         # RDS resource definitions (renamed from main.tf)
│       ├── variables.tf   # Input variables for the RDS module
│       └── outputs.tf     # Outputs for the RDS module
│
├── terraform.tfvars       # Global variable definitions
├── versions.tf            # Terraform and provider version settings
└── README.md              # Project documentation
</code></pre>

<h2>Apply the Terraform Configuration</h2>
<code>terraform init</code>code>

<h2>Plan the deployment</h2>
<code>terraform apply</code>code>

<h2>File Naming Conventions</h2>

<ul>
<li><strong>Resource Definition Files</strong>: Each module contains resource-specific <code>.tf</code> files, such as <code>vpc.tf</code> for VPC, <code>ec2.tf</code> for EC2, and so on, instead of a generic <code>main.tf</code> file.</li>
<li><strong>variables.tf</strong>: Contains the input variables for the module or environment.</li>
<li><strong>outputs.tf</strong>: Defines the output variables that are exposed after resource creation.</li>
<li><strong>terraform.tfvars</strong>: Contains environment-specific variable values (not version-controlled, recommended to be ignored in <code>.gitignore</code>).</li>
</ul>

<h2>Adding New Resources or Environments</h2>

<h3>Adding a New Environment</h3>

<ol>
<li>Navigate to the <code>environments/</code> directory.</li>
<li>Create a new directory for the environment (e.g., <code>test</code>, <code>staging</code>, or <code>prod</code>).</li>
<li>Within the new directory, create <code>main.tf</code>, <code>variables.tf</code>, and <code>outputs.tf</code>.
<ul>
<li>Use <code>main.tf</code> to define the environment-specific resources.</li>
<li>Use <code>variables.tf</code> to declare any
