#!/bin/bash
echo "📦 Deploying S3 Buckets..."

# Criar buckets
awslocal s3 mb s3://meu-app-bucket
awslocal s3 mb s3://meu-website-bucket

# Upload de arquivos de exemplo
awslocal s3 cp /app/data/website/ s3://meu-website-bucket/ --recursive
awslocal s3 cp /app/data/sample-data.json s3://meu-app-bucket/

# Configurar website hosting
awslocal s3 website s3://meu-website-bucket/ --index-document index.html

echo "✅ S3 buckets deployed!"
