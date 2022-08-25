# AWS DNA 장애대응 솔루션 : Jarvis 장애대응 해줘 ~!

## MSA Application
```
선택한 MSA 예제 : Sock-shop
```
## aws service to use
```
EKS, Cloudwatch, S3, Lambda, SNS, Fis, Managed Grafana
Chatbot, WAF, Route53, Certificate Manager etc .
```

## Open source to use
```
Terraform, Helm, Botkube, Chaos Mesh, Pixie, fluent bit
```

## Architecture
![image](https://user-images.githubusercontent.com/50174803/186666219-43aad2eb-9fda-4231-b68e-bdd37975ee30.png)

![image](https://user-images.githubusercontent.com/50174803/186666358-427f7d1a-02e1-436f-b37c-8282eb87d4a3.png)

## Scenario

```
[ Scale HPA MaxReplicas ]
Fis & Chaos Mesh를 통해 특정 deployment (front-end)로 Stress 보냅니다.
그렇게 되면, front-end 파드들의 CPU 사용량이 증가하게 됩니다.

파드의 메트릭 지표를 수집하고 있는 Cloudwatch daemonset이 
Cloudwatch로 높은 CPU사용량에 대한 메트릭을 보내면, Cloudwatch 의 Alert Condition에 
걸려서 SNS를 트리거하고 이 SNS가 슬랙의 특정 채널로 Cloudwatch Alert을 보냅니다.

Alert을 확인한 이후에 Botkube를 이용해, 현재 Pod의 상태과 HPA의 상태를 조회합니다.
그리고 실제 리소스 상태를 파악해보기 위해 Magnaged Grafana 에 접근합니다.
이 Managed Grafana는 SSO(Single-Sign-On) 을 통해 액세스 합니다.

매니지드 그라파나를 통해, front-end파드의 CPU이용량을 확인하고 파드의 로드밸런싱을 위해서
front-end HPA의 MaxReplcas 개수를 증가시킵니다.

이를 위해, aws chatbot이 특정 Lambda function에 payload를 넣어서 트리거(invoke)하면
Lambda function이 payload를 실어서 깃헙액션 api call을 하게 됩니다.

그러면 깃헙액션이 트리거되어, payload 값에 맞춰 특정 HPA의 개수를 증가시켜서 대응합니다.

[ Flow ]
A. Fis & Chaos Mesh로 Stress 주입 -> CloudWatch Alert 확인
B. Botkube & Managed Grafana 를 통한 리소스 상태 확인
C. awschatbot 으로 Lambda 실행
D. 람다가 깃헙액션 실행해서 대응 

```

```
[ Rollout Restart ]
deployment를 restart시키는 케이스가 다양하기 때문에, 상황을 가정해보겠습니다.
어떠한 애플리케이션이 현재 EKS위에 있습니다.
이 애플리케이션은 front-end라는 deployment 이고, 여기에는 front-end container 뿐 만아니라
init-container로 Vault-container가 있는 상황입니다.

Hashicorp Vault가 init-container로 동작한 이후, front-end 컨테이너의 특정 Path로 
Vault의 Secret Engine에 저장된 시크릿 키값들을 마운트할 수 있습니다.



```
