#!/bin/bash
cat << END
Description : This Script is for the 2022 AWS DNA project.
Usage       : For AWS EKS, Install kubectl, eksctl, awscli2, terraform
OS          : amazon linux2
Author      : "sangwon lee" <lee2155507@naver.com>

END

K8s(){
echo "Install kubectl"
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl

if [[ "${?}" -ne 0 ]]
then
        echo "Kubectl Install Failed."
        exit 1
fi
echo "Install kubectl success"
sudo chmod +x /usr/local/bin/kubectl
kubectl
sudo yum install -y jq
sudo yum install -y bash-completion

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
alias k=kubectl
complete -F __start_kubectl k

echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

if [[ "${?}" -ne 0 ]]
then
        echo "eksctl Install Failed."
        exit 1
fi
sudo mv -v /tmp/eksctl /usr/local/bin
eksctl version
}

Awscli(){
echo "Install AWSCLI2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
source ~/.bashrc
aws --version
echo "Install awscli2 success."
}
Terraform(){
    echo "Install Terraform"
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
    terraform -help
}

Helm(){
   echo "Install Helm"
   curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
   chmod 700 get_helm.sh
   ./get_helm.sh
   if [[ "${?}" -ne 0 ]]
   then
        echo "helm Install Failed."
        exit 1
   fi
   rm get_helm.sh
}

Appmesh(){
   echo "Install App mesh"
   curl -o pre_upgrade_check.sh https://raw.githubusercontent.com/aws/eks-charts/master/stable/appmesh-controller/upgrade/pre_upgrade_check.sh
   sh ./pre_upgrade_check.sh

   echo "Install Helm eks-charts & Apply App Mesh CRD"
   helm repo add eks https://aws.github.io/eks-charts
   kubectl apply -k "https://github.com/aws/eks-charts/stable/appmesh-controller/crds?ref=master"

   echo "Create ns appmesh-system"
   kubectl create ns appmesh-system

   export CLUSTER_NAME=aws-dna
   export AWS_REGION=ap-northeast-1

   echo "Create OIDC identity provier"
   eksctl utils associate-iam-oidc-provider --region=$AWS_REGION --cluster $CLUSTER_NAME --approve

   echo "Create IAM Role attach AWSAppMeshFullAccess and AWSCloudMapFullAccess"
   eksctl create iamserviceaccount --cluster $CLUSTER_NAME \
    --namespace appmesh-system \
    --name appmesh-controller \
    --attach-policy-arn  arn:aws:iam::aws:policy/AWSCloudMapFullAccess,arn:aws:iam::aws:policy/AWSAppMeshFullAccess \
    --override-existing-serviceaccounts \
    --approve

   echo "Deploy App Mesh Controller"
   helm upgrade -i appmesh-controller eks/appmesh-controller \
    --namespace appmesh-system \
    --set region=$AWS_REGION \
    --set serviceAccount.create=false \
    --set serviceAccount.name=appmesh-controller
}


BAR="===================================="
echo "${BAR}"
echo "What do you want ? "
echo "${BAR}"
echo "[0] Install kubectl & eksctl"
echo "[1] Install Amazon CLI2"
echo "[2] Install Terraform"
echo "[3] Install Helm"
echo "[4] Apply AppMesh"


echo "${BAR}"
echo -n "Please insert a key as you need = "
read choice
echo "${BAR}"
case $choice in
        0) K8s;;
        1) Awscli;;
        2) Terraform;;
        3) Helm;;
        4) Appmesh;;
        *) echo "Bad choice"
                exit 1
esac
