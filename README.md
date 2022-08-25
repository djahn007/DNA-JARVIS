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
C. awschatbot 으로 Lambda function scale 실행 
D. Scale lambda function이 깃헙액션 scale.yml 실행
E. 특정 namespace에 존재하는 특정 hpa에 설정한 maxreplicas 로 설정됨 
F. CPU 를 많이 받고 있고, HPA의 스케일이 CPU사용량에 따라 증가된다면 HPA에 의해 파드개수가
증가하여 로드밸런싱되어 각 파드가 받는 CPU감소 

```

```
[ Rollout Restart ]
deployment를 restart시키는 케이스가 다양하기 때문에, 상황을 가정해보겠습니다. (쓸데없이 긴 내용입니다.) 
어떠한 애플리케이션이 현재 EKS위에 있습니다.
이 애플리케이션은 front-end라는 deployment 이고, 여기에는 front-end container 뿐 만아니라
init-container로 Vault-container가 있는 상황입니다.

Hashicorp Vault가 init-container로 동작한 이후, front-end 컨테이너의 특정 Path로 
Vault의 Secret Engine에 저장된 시크릿 키값들을 마운트할 수 있습니다.

이 시크릿 키 값이 어떤 채널로 매트릭을 수집해서 보낼 수 있도록 하는 라이센스 키인데, 이 키가 노출되어 이 키를 deactive 시키고
새 키를 발급받아서 Vault 에 업데이트 한 이후, 그대로 퇴근합니다.

그러다, 개발팀에게 현재 어떤 지표가 안보인다는 연락이 옵니다. 
이런 상황일 때, 특정 deployment를 restart할 수 있도록 합니다.

[ Flow ]
A. Secret Key 업데이트 후, 파드 재시작 하지 않음
B. Botkube를 통해 파드가 언제 시작되었는지 age 확인
C. 파드 재시작이 되지 않았다면, aws chatbot으로 lambda function restart 실행
D. Restart lambda function이 깃헙액션 restart.yml 실행
E. 특정 deployment 특정 namespace에서 Restart
```

```
[ Helm Rollback ]
EKS에서 애플리케이션을 운영하기 때문에, kubernetes manifest파일은 Helm를 이용해 배포합니다.
Production 환경에 배포 이후, 어떤 취약점이 발견되거나 혹은 issue raising으로 인해 
롤백해야 하는 상황이 생길 수 있습니다.

혹은 helm 으로 배포할 때, helm status가 pending-upgrade or failed 여서 이를 복구하기 위해
롤백해야할 수도 있습니다.

이 떄 챗봇을 이용해 롤백합니다.

[ Flow ]
A. 롤백을 해야하는 상황이 발생
B. aws chatbot을 통해 lambda function rollback을 실행
C. Rollback lambda functions은 깃헙액션 Rollback.yml 실행
D. 특정 revision, 특정 version 으로 Rollback 
```

```
[ Change WAF-ID ]
EKS 에서 운영 중인 애플리케이션에 접근하기 위해, ingress에 등록된 host를 통해 접근한다.
이 때, 이 ingress annotation에 waf를 추가해서, waf-id가 (allow-waf) public하게 open 되어 있으면
이 host ( https://www.msa.jarvis-awsdna.com ) 에 접근할 수 있고, 

waf-id가 (deny-waf) 라면 접근할 수 없다. (403 Forbidden)

챗봇으로 특정 장애상황에 대해 대응이 안되는 상황일 때, 사이트 접근 자체를 막고
긴급점검 페이지로 redirect되도록 설정하도록 하는 상황이다.

[ Flow ]
A. 사이트 접근 자체를 차단해야할 일이 발생한다.
B. aws chatbot을 통해 lambda function update-waf를 실행한다
C. update-waf lambda functions은 깃헙액션 update-waf.yml 실행
D. 특정 namespace에 있는 특정 ingress의 waf-id가 달라져서 
```

```
waf-id가 allow 일 때
```
![image](https://user-images.githubusercontent.com/50174803/186718642-ea3b642e-8c7c-4676-ba93-f11b763acb72.png)


```
waf-id가 deny 일 때
WAF의 custom error page로 redirect . 
```

![image](https://user-images.githubusercontent.com/50174803/186719248-ea79ec27-82a0-430d-b1f1-22420bbc69b2.png)
