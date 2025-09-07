#!/bin/bash
# test-lambda.sh
echo "🧪 Testing Lambda function..."

FUNCTION_NAME="minha-funcao"

# Teste 1: Evento vazio
echo "1. Testing with empty event..."
awslocal lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload '{}' \
    test-output-1.json
cat test-output-1.json
echo ""

# Teste 2: Com dados
echo "2. Testing with data..."
awslocal lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload '{"name": "Test User", "action": "test"}' \
    test-output-2.json
cat test-output-2.json
echo ""

# Teste 3: Com logs
echo "3. Testing with logs..."
awslocal lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload '{"debug": true}' \
    --log-type Tail \
    test-output-3.json | jq -r '.LogResult' | base64 -d

echo "✅ Tests completed!"