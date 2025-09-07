#!/bin/bash
echo "🖥️ Deploying EC2 Infrastructure..."

# Criar VPC
VPC_ID=$(awslocal ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)

# Criar Subnet
SUBNET_ID=$(awslocal ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text)

# Criar Security Group
SG_ID=$(awslocal ec2 create-security-group --group-name meu-sg --description "Meu Security Group" --vpc-id $VPC_ID --query 'GroupId' --output text)
awslocal ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
awslocal ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0

# Criar Key Pair
awslocal ec2 create-key-pair --key-name minha-key --query 'KeyMaterial' --output text > app/minha-key.pem
chmod 400 app/minha-key.pem

# Criar Instância EC2
INSTANCE_ID=$(awslocal ec2 run-instances \
    --image-id ami-12345678 \
    --instance-type t2.micro \
    --key-name minha-key \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --count 1 \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "✅ EC2 Infrastructure deployed!"
echo "📋 Instance ID: $INSTANCE_ID"
echo "🔑 Key saved: app/minha-key.pem"
