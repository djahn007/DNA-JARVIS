# AWS DNA

## MSA Application
```
선택한 MSA 예제 : Sock-shop

```
## aws service to use
```
EKS, Cloudwatch, S3, Lambda, Athena, Quicksight
Chatbot, WAF, Route53, CloudTrail, Managed Grafana, SNS etc .

```

## Flow
```
Step1. Visualization

a. Cloudwatch container insights Setting
b. Managed Grafana + Pixie
(https://github.com/pixie-io/grafana-plugin/)
(https://github.com/pixie-io/pixie)
c. Alert Setting (Metric : CPU, Memory)
d. Dashboard Setup ( Metric / Service Map )

Step2. ChatOps

a. botkube Setup
b. AWS Chatbot Setup
c. Cloudwatch , SNS Setup
d. Lambda Setup (ex. listPods, Rollback)

Step3. log-based report or Dashboard
a. Cloudwatch -> Lambda -> S3
b. Athena + QuickSight
```

## what we are working on
```
[ helm chart update & test ]
* ingress에 host , annotation WAF setting & test
* Apply HPA
*

[ Chatbot update & test ]
* chatbot command : create helm rollback functions
* chatbot command : create change ingress waf id (maybe kubectl patch ..)

[ Logging (not yet)]
* AWS Chatbot or botkube 둘다 EKS api-server logging enabled 설정해야, 봇으로 쿠버네티스에 보낸 커맨드 로그 수집 가능
* 이 로그 바탕으로 Cloudwatch -> S3 -> Athena -> QuicksSight까지.

```