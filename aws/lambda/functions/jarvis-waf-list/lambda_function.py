from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os


SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
BOT_TOKEN = os.environ['BOT_TOKEN']
ALLOW_WAF_ID = os.environ['ALLOW_WAF_ID']
DENY_WAF_ID = os.environ['DENY_WAF_ID']

def post_slack():
    client = WebClient(token=BOT_TOKEN)
    blocks = [
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "Allow WAF ID",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": ALLOW_WAF_ID,
				"emoji": True
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "Deny WAF ID",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": DENY_WAF_ID,
				"emoji": True
			}
		},
		{
			"type": "divider"
		}
    ]

    try:
        response = client.chat_postMessage(
            channel=SLACK_CHANNEL,
            blocks=blocks
        )

    except SlackApiError as e:
        print(f"Error posting message: {e}")

def lambda_handler(event, context):
    post_slack()
    return "👆 WAF ID를 이용하여 후속 작업을 실행해주세요."
