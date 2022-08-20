## Usage botkube

## 1. helm chart update
```
helm repo add botkube https://charts.botkube.io
helm repo update
```

## 2. Deploy helm chart to k8s
```
helm upgrade --install --version v0.12.4 botkube --namespace botkube --create-namespace \
--set communications.slack.enabled=true \
--set communications.slack.channel=kubebot \
--set communications.slack.token=$SLACK_TOKEN \
--set config.settings.clustername=jarvis-ap-northeast-2 \
--set config.settings.kubectl.enabled=true \
--set image.tag=v0.12.4 botkube/botkube
```
## RBAC Update

### 1. Update Clusterrole
```
[as-is]
rules:
  - verbs:
      - get
      - watch
      - list
--------------------------
[to-be]
rules:
  - verbs:
      - get
      - watch
      - list
      - patch
      - delete
      - create
```
### 2. Update configmap
```
[to-be]
kubectl:
  commands:
    resources:
    - deployments
    - pods
    - namespaces
    - daemonsets
    - statefulsets
    - storageclasses
    - nodes
    - ingresses
    - services
    verbs:
    - api-resources
    - api-versions
    - cluster-info
    - describe
    - diff
    - explain
    - get
    - logs
    - top
    - auth
    - delete
    - patch
    - create
    - watch
    - list
```