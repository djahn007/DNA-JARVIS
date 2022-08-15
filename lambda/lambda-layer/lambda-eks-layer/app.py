import base64
import json
import boto3
import re
import os
import logging
from botocore.signers import RequestSigner
from kubernetes import client, config
import logging.handlers
import urllib3


urllib3.disable_warnings()
logger = logging.getLogger()
# logger.setLevel('WARN')

# config.load_incluster_config()
# v1 = client.CoreV1Api()
# ret = v1.list_pod_for_all_namespaces(watch=False)


def get_bearer_token(cluster_id, region):
    STS_TOKEN_EXPIRES_IN = 60
    session = boto3.session.Session()

    client = session.client('sts', region_name=region)
    service_id = client.meta.service_model.service_id

    signer = RequestSigner(
        service_id,
        region,
        'sts',
        'v4',
        session.get_credentials(),
        session.events
    )

    params = {
        'method': 'GET',
        'url': 'https://sts.{}.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15'.format(region),
        'body': {},
        'headers': {
            'x-k8s-aws-id': cluster_id
        },
        'context': {}
    }

    signed_url = signer.generate_presigned_url(
        params,
        region_name=region,
        expires_in=STS_TOKEN_EXPIRES_IN,
        operation_name=''
    )
    base64_url = base64.urlsafe_b64encode(signed_url.encode('utf-8')).decode('utf-8')
    # remove any base64 encoding padding:
    return 'k8s-aws-v1.' + re.sub(r'=*', '', base64_url)
    # If making a HTTP request you would create the authorization headers as follows:
    # headers = {'Authorization': 'Bearer ' + get_bearer_token('my_cluster', 'us-east-1')}


def list_pod_for_all_ns():
    ApiToken = get_bearer_token(os.environ['CLUSTER_NAME'], os.environ['CLUSTER_REGION'])
    configuration = client.Configuration()
    configuration.host = os.environ['CLUSTER_ENDPOINT']
    configuration.verify_ssl = False
    configuration.debug = False
    configuration.api_key = {"authorization": "Bearer " + ApiToken}
    client.Configuration.set_default(configuration)
    v1 = client.CoreV1Api()
    all_pods_names = [i.metadata.name for i in v1.list_pod_for_all_namespaces(watch=False).items]
    logger.info(all_pods_names)
    return all_pods_names


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps({
            "pods": list_pod_for_all_ns(),
        }),
    }
