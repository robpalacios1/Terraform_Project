# Terraform AWS Infrastructure Project

This Terraform project provisions a complete AWS infrastructure setup including a VPC, subnet, security group, and EC2 instance for hosting a web server.

## Overview

This project creates a basic AWS infrastructure stack that includes:

- A Virtual Private Cloud (VPC)
- A public subnet in a specific availability zone
- A security group configured for web traffic
- An EC2 instance to host a web server

## Prerequisites

Before using this project, ensure you have the following installed and configured:

- **Terraform** (version 1.0 or later)
- **AWS CLI** configured with appropriate credentials
- **AWS Account** with necessary permissions to create VPC, EC2, and security group resources
- **SSH Key Pair** named `aws-key` in the `us-east-1` region

### Required AWS Permissions

Your AWS credentials must have permissions to:

- Create and manage VPCs
- Create and manage subnets
- Create and manage security groups
- Launch EC2 instances
- Create and manage tags

## Project Structure

```
Terraform_Project/
├── main.tf          # Main infrastructure resources
├── provider.tf      # AWS provider configuration
├── outputs.tf       # Output values
└── README.md        # Project documentation
```

## Infrastructure Components

### 1. VPC (Virtual Private Cloud)

- **CIDR Block**: `10.0.0.0/16`
- **Name**: `main_vpc`
- Provides an isolated network environment for your AWS resources

### 2. Subnet

- **CIDR Block**: `10.0.1.0/24`
- **Availability Zone**: `us-east-1a`
- **Name**: `main_subnet`
- Subnet within the VPC for hosting EC2 instances

### 3. Security Group

- **Name**: `web_sg`
- **Description**: Web security group
- **Inbound Rules**:
  - SSH (port 22) from anywhere (`0.0.0.0/0`)
  - HTTP (port 80) from anywhere (`0.0.0.0/0`)
- **Outbound Rules**:
  - All traffic allowed to anywhere
- **Name**: `web_sg`

### 4. EC2 Instance

- **Instance Type**: `t3.micro`
- **AMI**: `ami-0cae6d6fe6048ca2c` (Amazon Linux 2)
- **Key Pair**: `aws-key` (must exist in AWS)
- **Name**: `web_server`
- Deployed in the subnet with the web security group attached

## Configuration

### Provider Configuration

The project uses the AWS provider version `~> 5.0` and is configured for the `us-east-1` region. You can modify the region in `provider.tf` if needed.

### Key Configuration Points

- **Region**: `us-east-1` (configurable in `provider.tf`)
- **AMI**: `ami-0cae6d6fe6048ca2c` (Amazon Linux 2 in us-east-1)
- **Key Pair**: `aws-key` (must be created in AWS Console or via AWS CLI)
- **Instance Type**: `t3.micro` (eligible for AWS Free Tier)

## Usage

### Initial Setup

1. **Clone or navigate to the project directory**:

   ```bash
   cd Terraform_Project
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

3. **Review the execution plan**:

   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```
   Type `yes` when prompted to confirm the deployment.

### Accessing the Web Server

After deployment, Terraform will output the public IP address of the EC2 instance. You can:

- **SSH into the instance**:

  ```bash
  ssh -i /path/to/aws-key.pem ec2-user@<public_ip>
  ```

- **Access via HTTP**:
  Open `http://<public_ip>` in your web browser (after configuring a web server on the instance)

### Outputs

The project outputs the following information:

- `web_server_public_ip`: The public IP address of the EC2 instance

To view outputs after deployment:

```bash
terraform output
```

## Important Notes

### Security Considerations

⚠️ **Warning**: The security group configuration allows SSH and HTTP traffic from anywhere (`0.0.0.0/0`). For production environments, consider:

- Restricting SSH access to specific IP addresses
- Using HTTPS instead of HTTP
- Implementing additional security layers

### Key Pair Requirement

The EC2 instance requires an SSH key pair named `aws-key` in the `us-east-1` region. If you don't have this key pair:

1. **Create via AWS Console**:

   - Navigate to EC2 → Key Pairs
   - Create a new key pair named `aws-key`
   - Download the private key file

2. **Create via AWS CLI**:
   ```bash
   aws ec2 create-key-pair --key-name aws-key --region us-east-1 --query 'KeyMaterial' --output text > aws-key.pem
   chmod 400 aws-key.pem
   ```

### AMI ID

The AMI ID `ami-0cae6d6fe6048ca2c` is specific to the `us-east-1` region. If you change the region, you'll need to update the AMI ID to match the target region.

## Destroying Infrastructure

To tear down all resources created by this project:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

⚠️ **Warning**: This will permanently delete all resources, including the EC2 instance and any data stored on it.

## Troubleshooting

### Common Issues

1. **Key Pair Not Found**:

   - Ensure the key pair `aws-key` exists in the `us-east-1` region
   - Verify the key pair name matches exactly

2. **AMI Not Found**:

   - The AMI ID may be outdated or region-specific
   - Find the correct AMI ID for your region using:
     ```bash
     aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query 'Images[*].[ImageId,Name]' --output table
     ```

3. **Insufficient Permissions**:

   - Verify your AWS credentials have the necessary IAM permissions
   - Check AWS CloudTrail for permission denied errors

4. **Region Mismatch**:
   - Ensure the provider region matches where you want to deploy resources
   - Verify the AMI exists in the target region

## Cost Estimation

The resources created by this project are eligible for the AWS Free Tier (for new AWS accounts):

- **t3.micro instance**: Free for 750 hours/month (first 12 months)
- **VPC and Subnet**: Free
- **Security Group**: Free
- **Data Transfer**: Charges may apply after free tier limits

For existing accounts or extended usage, approximate costs:

- **t3.micro**: ~$0.0104/hour (~$7.50/month if running 24/7)
- **Data Transfer**: Varies by usage

## Contributing

This is a personal project, but suggestions and improvements are welcome.

## License

This project is provided as-is for educational and development purposes.

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform Documentation](https://www.terraform.io/docs)
