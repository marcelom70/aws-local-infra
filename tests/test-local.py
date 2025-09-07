# Testar a função localmente primeiro
import lambda_function

# Teste direto
result = lambda_function.lambda_handler({"name": "Local Test"}, None)
print("Resultado:", result)

# Teste com evento mais complexo
event = {
    "httpMethod": "GET",
    "queryStringParameters": {"name": "Python Test"},
    "path": "/test"
}
result = lambda_function.lambda_handler(event, None)
print("Resultado completo:", result)