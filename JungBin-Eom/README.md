# Incident Response Architecture Based on X-Ray
1. 간단한 마이크로서비스 애플리케이션을 쿠버네티스 클러스터로 배포합니다.
2. X-Ray를 통해 각 서비스들의 통신 상태를 tracing 합니다.
3. X-Ray에서 문제가 발생하면 CloudWatch 알람을 trigger하는 Lambda 함수를 호출합니다.
4. Lambda 함수는 CloudWatch 알람을 trigger합니다.
5. SNS을 통해 관리자 email로 이슈를 보고합니다.
6. 시스템 관리자는 X-Ray 대시보드를 통해 장애에 대응합니다.  

</br>

**추가하고 싶은 것**  
- 대준님께서 제안해주신 로그 저장 및 파싱을 3번 단계에 추가하여 관리자에게 장애 정보를 함께 전달할 수 있으면 좋겠습니다.  
- 혹은 대준님의 아이디어에서 X-Ray를 추가하여 아키텍처를 구성해보면 좋을 것 같습니다.