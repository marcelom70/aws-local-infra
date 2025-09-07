#!/bin/bash
echo "🌐 Deploying API Gateway..."

# Criar API
API_ID=$(awslocal apigateway create-rest-api --name minha-api --query 'id' --output text)

# Configurar recursos e métodos
ROOT_ID=$(awslocal apigateway get-resources --rest-api-id $API_ID --query 'items[0].id' --output text)
RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id $API_ID --parent-id $ROOT_ID --path-part "hello" --query 'id' --output text)

awslocal apigateway put-method --rest-api-id $API_ID --resource-id $RESOURCE_ID --http-method GET --authorization-type NONE
awslocal apigateway put-integration --rest-api-id $API_ID --resource-id $RESOURCE_ID --http-method GET --type AWS_PROXY --integration-http-method POST --uri "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:minha-funcao/invocations"

# Deploy
awslocal apigateway create-deployment --rest-api-id $API_ID --stage-name dev

# Permissão para API invocar Lambda
awslocal lambda add-permission \
    --function-name minha-funcao \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --statement-id apigateway-test \
    --source-arn "arn:aws:execute-api:us-east-1:000000000000:$API_ID/*/GET/hello"

echo "✅ API Gateway deployed: http://localhost:4566/restapis/$API_ID/dev/_user_request_/hello"
