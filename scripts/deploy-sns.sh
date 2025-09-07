#!/bin/bash
echo "📢 Deploying SNS Topics..."

# Criar tópico
awslocal sns create-topic --name meus-alertas

# Criar subscription (email fictício)
awslocal sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:meus-alertas \
    --protocol email \
    --notification-endpoint alertas@meudominio.com

echo "✅ SNS topic deployed!"
