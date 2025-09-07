#!/bin/bash
set -e  # Falha imediatamente se algum comando falhar

echo "🎯 DEPLOY COMPLETO DA INFRA AWS LOCAL"
echo "======================================"

# Aguardar LocalStack ficar pronto com timeout
echo "⏳ Aguardando LocalStack..."
TIMEOUT=60
COUNTER=0
while ! curl -s http://localhost:4566/health >/dev/null; do
    sleep 2
    COUNTER=$((COUNTER + 2))
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo "❌ Timeout: LocalStack não respondeu em ${TIMEOUT}s"
        exit 1
    fi
done

# Executar todos os scripts de deploy
echo "🚀 Implantando serviços..."
./scripts/deploy-lambda.sh || { echo "❌ Falha no deploy Lambda"; exit 1; }
./scripts/deploy-s3.sh || { echo "❌ Falha no deploy S3"; exit 1; }
./scripts/deploy-dynamodb.sh || { echo "❌ Falha no deploy DynamoDB"; exit 1; }
./scripts/deploy-sns.sh || { echo "❌ Falha no deploy SNS"; exit 1; }
./scripts/deploy-apigateway.sh || { echo "❌ Falha no deploy API Gateway"; exit 1; }
./scripts/deploy-ec2.sh || { echo "❌ Falha no deploy EC2"; exit 1; }

echo "✅ DEPLOY COMPLETO!"
echo "🌐 Health Check:"
curl -s http://localhost:4566/health | jq .
