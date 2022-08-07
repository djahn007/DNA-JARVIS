# AWS DNA

## MSA Application
```
선택한 MSA 예제 : Sock-shop

참고
https://gasidaseo.notion.site/MSA-12-382799b72d5d49a9a15dcafd123c1aa8#266dcdb1c33d419bad99866d504badbb

```
## aws service to use
```
Xray + app mesh
```
## what i'm working on
```
1) init setup script
2) Create helm chart
3) Testing Xray + app mesh
...

개인적으로 테스트할 때, 쉽게 설치해서 사용할 수 있도록 하는 init.sh 작성중

sock-shop를 위한 helm-chart 만드는 중
아래 명령어를 통해서 받아오는 manifest 파일을 커스텀하게 세팅할 수 있도록
헬름 차트 만들고 + 수정중

curl -O https://raw.githubusercontent.com/microservices-demo/microservices-demo/master/deploy/kubernetes/complete-demo.yaml

xray + app mesh test & apply
```