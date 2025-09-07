#!/bin/bash
echo "🗄️ Deploying DynamoDB Tables..."

# Criar tabela
awslocal dynamodb create-table \
    --table-name Usuarios \
    --attribute-definitions \
        AttributeName=id,AttributeType=S \
        AttributeName=email,AttributeType=S \
    --key-schema \
        AttributeName=id,KeyType=HASH \
        AttributeName=email,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST

# Inserir dados iniciais
awslocal dynamodb put-item \
    --table-name Usuarios \
    --item '{
        "id": {"S": "1"},
        "email": {"S": "joao@email.com"},
        "nome": {"S": "João Silva"},
        "idade": {"N": "30"},
        "ativo": {"BOOL": true}
    }'

awslocal dynamodb put-item \
    --table-name Usuarios \
    --item '{
        "id": {"S": "2"},
        "email": {"S": "maria@email.com"},
        "nome": {"S": "Maria Santos"},
        "idade": {"N": "25"},
        "ativo": {"BOOL": true}
    }'

echo "✅ DynamoDB table populated!"
