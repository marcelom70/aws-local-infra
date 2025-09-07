#!/bin/bash
# deploy-lambda.sh
echo "📦 Building Lambda package..."

# Limpar builds anteriores
rm -rf ./functions/package/
rm -f function.zip

# Criar diretório para dependências
mkdir -p ./functions/package

# Instalar APENAS dependências necessárias
if [ -f "./functions/requirements.txt" ]; then
    pip install -r ./functions/requirements.txt -t ./functions/package/ --no-cache-dir
else
    echo "⚠️  No requirements.txt, installing only function"
fi

# Criar ZIP (APENAS o necessário)
cd ./functions/package
zip -r ../../function.zip . --exclude "*.pyc" "**/__pycache__/*"
cd ../../

# Adicionar APENAS seu código fonte
zip -g function.zip lambda_function.py

# Verificar tamanho
SIZE=$(du -h function.zip | cut -f1)
echo "✅ Package created: function.zip (${SIZE})"

if [ $(du -m function.zip | cut -f1) -gt 50 ]; then
    echo "⚠️  Warning: Package is larger than 50MB"
    echo "💡 Tips: Remove unnecessary dependencies from requirements.txt"
fi

# Criar função
awslocal lambda create-function \
    --function-name minha-funcao \
    --runtime python3.9 \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --zip-file fileb://function.zip

echo "✅ Lambda function deployed!"
