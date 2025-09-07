# lambda_function.py (exemplo completo)
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Event received: %s", json.dumps(event))
    
    # Diferentes tipos de entrada
    if 'httpMethod' in event:
        # Veio do API Gateway
        name = event.get('queryStringParameters', {}).get('name', 'Unknown')
        response = {
            'statusCode': 200,
            'body': json.dumps({'message': f'Hello {name} from API Gateway, again!'})
        }
    else:
        # Invocação direta
        name = event.get('name', 'World')
        response = {
            'message': f'Hello {name} from direct invocation!',
            'event': event
        }
    
    logger.info("Response: %s", response)
    return response
