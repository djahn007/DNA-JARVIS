import json
import os
import requests

TOKEN = os.environ.get("GITHUB_TOKEN")
OWNER = os.environ.get("GITHUB_OWNER")
REPO = os.environ.get("GITHUB_REPO")

def lambda_handler(event, context):
    headers = {
      "Accept": "application/vnd.github+json",
      "Authorization": f"token {TOKEN}",
    }

    WAF_ID = event['waf-id']
    NAME = event['name']
    KIND = event['kind']
    NAMESPACE = event['namespace']

    data = {
      "event_type": "patch-waf",
      "client_payload": {"waf-id": WAF_ID,"name": NAME,"kind": KIND,"namespace": NAMESPACE}
    }

    url = f"https://api.github.com/repos/{OWNER}/{REPO}/dispatches"
    request = requests.post(
      url= url,
      data=json.dumps(data),
      headers=headers
    )

    print(request)

    return "<https://dna-jarvis.slack.com/archives/C03UJ71D42G|#jarvis-infra-alert>을 확인해주세요."
