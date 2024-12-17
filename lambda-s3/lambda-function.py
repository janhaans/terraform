import json

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")   
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        print(f"New object added: {object_key} in bucket: {bucket_name}")
    return {
        'statusCode': 200,
        'body': json.dumps('Event processed successfully!')
    }
