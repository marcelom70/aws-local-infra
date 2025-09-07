import json
import boto3

def lambda_handler(event, context):
    print("Event received:", event)
    
    # Exemplo de uso do DynamoDB
    dynamodb = boto3.resource(
        'dynamodb',
        endpoint_url='http://localhost:4566',
        region_name='us-east-1',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    table = dynamodb.Table('Usuarios')
    response = table.scan()
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'users_count': len(response['Items']),
            'event': event
        })
    }
