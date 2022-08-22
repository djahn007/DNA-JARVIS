from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os


SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
BOT_TOKEN = os.environ['BOT_TOKEN']

def post_slack():
    client = WebClient(token=BOT_TOKEN)
    blocks = [
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "jarvis-update-waf",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "waf id를 변경합니다. lambda 실행시, 아래 payload 값을 넣어주세요.",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "```{\"waf-id\": WAF_ID, \"name\": NAME, \"kind\": KIND, \"namespace\": NAMESPACE}```"
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "jarvis-helm-rollback",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "rollback을 진행합니다. lambda 실행시, 아래 payload 값을 넣어주세요.",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "```{\"release-name\": RELEASE_NAME, \"version\": VERSION, \"namespace\": NAMESPACE}```"
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "jarvis-restart-deploy",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "배포를 재시작합니다. lambda 실행시, 아래 payload 값을 넣어주세요.",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "```{\"deployment-name\": DEPLOYMENT_NAME, \"namespace\": NAMESPACE }```"
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "jarvis-waf-list",
				"emoji": True
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "allow waf id, deny waf id 를 확인할 수 있습니다.",
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
    return "🤖"
