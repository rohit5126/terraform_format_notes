# DevBoard on EKS

DevBoard is a task-tracking app (Go API + React/Vite frontend + Postgres) deployed on Amazon EKS, provisioned with Terraform.

- **Cluster:** `devboard`
- **Region:** `eu-north-1`
- **Namespace:** `devboard-app`

## Architecture


  <img width="385" height="606" alt="Screenshot From 2026-07-20 13-30-23" src="https://github.com/user-attachments/assets/1733ec72-8acd-467a-a419-0c2467400fc6" />

---

### Supporting infrastructure:

- **VPC** — 2 public subnets (ALB, NAT gateway) + 2 private subnets (EKS node group), single NAT gateway
- **EKS cluster** — v1.34, one managed node group, `t3.medium` instances

  <img width="777" height="450" alt="Screenshot From 2026-07-20 13-28-30" src="https://github.com/user-attachments/assets/456b6989-3faf-4071-b23f-1d7cbdd9fd73" />

- **Amazon EBS CSI Driver** — EKS-managed addon; provisions the EBS volume backing Postgres's PVC
- **AWS Load Balancer Controller** — installed via Helm; provisions the ALB from the `Ingress` object
- Both add-ons authenticate to AWS via **IRSA** (IAM Roles for Service Accounts)

  <img width="718" height="409" alt="Screenshot From 2026-07-20 13-29-24" src="https://github.com/user-attachments/assets/0789294b-efa0-42c0-86f5-434d83adb760" />


## Repository layout

```
EKS-Cluster/
├── terraform.tf              # required_providers block
├── providers.tf              # AWS provider, region eu-north-1
├── variables.tf              # cluster name/version, CIDRs, instance type, tags
├── vpc.tf                     # VPC module (subnets, NAT gateway, AZ discovery)
├── main.tf                    # EKS cluster + managed node group
├── ebs-csi.tf                 # EBS CSI driver IRSA role + EKS addon
├── lb-controller-irsa.tf      # Load Balancer Controller IRSA role + IAM policy
├── iam_policy.json            # official AWS-published IAM policy for the LB controller
└── outputs.tf                 # cluster endpoint, name, security group id

EKS-terraform-K8s/
├── namespace.yml
├── 01-secrets-and-config.yaml # Postgres credentials + init-script ConfigMap
├── 02-serviceaccounts.yaml    # frontend + backend ServiceAccounts (backend has IRSA annotation)
├── 03-postgres-statefulset.yaml
├── 04-backend.yaml             # backend Deployment, Service, HPA
├── 05-frontend.yaml      # frontend Deployment, Service, HPA
├── 06-ingress.yaml            # ALB Ingress routing to frontend-service
├── 07-network-policies.yaml   # default-deny baseline + explicit allow rules
├── 01_schema.sql
└── 02_seed.sql
```

## Prerequisites

- AWS CLI configured with credentials for the target account
- Terraform `~> 1.5+`
- `kubectl`
- `helm` (for the Load Balancer Controller install)
- Docker (only needed if you rebuild the app images)

## Setup — from scratch

### 1. Provision the network + cluster

```bash
cd EKS-terraform
terraform init
terraform apply
```

This creates the VPC, the EKS cluster, and the managed node group. Note the AMI is **left as the module default** (Amazon Linux 2023) — do not hardcode a custom `ami_id` unless you also set `ami_type = "CUSTOM"` and supply your own bootstrap user-data, or nodes will launch but never join the cluster.

### 2. Point kubectl at the new cluster

```bash
aws eks update-kubeconfig --name devboard --region eu-north-1
kubectl get nodes   # confirm nodes show Ready
```

### 3. Confirm the EBS CSI driver is healthy

Installed automatically by `ebs-csi.tf` as part of step 1.

```bash
kubectl get pods -n kube-system | grep ebs-csi
```

Both `ebs-csi-controller-*` pods and the `ebs-csi-node-*` daemonset should be `Running`.

### 4. Install the AWS Load Balancer Controller

The IAM role/policy are created by Terraform (`lb-controller-irsa.tf`), but the controller itself is installed separately via Helm:

```bash
terraform output lb_controller_role_arn   # grab the ARN

helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Get your VPC id
aws eks describe-cluster --name devboard --region eu-north-1 --query "cluster.resourcesVpcConfig.vpcId" --output text

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=devboard \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<paste-the-arn> \
  --set region=eu-north-1 \
  --set vpcId=<your-vpc-id>

kubectl get deployment -n kube-system aws-load-balancer-controller
```

### 5. Apply the application manifests, in order

```bash
cd manifests
kubectl apply -f namespace.yml
kubectl apply -f 01-secrets-and-config.yaml
kubectl apply -f 02-serviceaccounts.yaml

kubectl apply -f 03-postgres-statefulset.yaml
kubectl rollout status statefulset/postgres -n devboard-app

kubectl apply -f 04-backend.yaml
kubectl rollout status deployment/backend-deployment -n devboard-app

kubectl apply -f 05-frontend.yaml
kubectl rollout status deployment/frontend-deployment -n devboard-app

kubectl apply -f 06-ingress.yaml
kubectl apply -f 07-network-policies.yaml   # last — see note below
```

> Apply network policies **last**. The `default-deny-all` baseline blocks all traffic (including ALB health checks) until the explicit allow rules are in place, so confirm the app works first.

### 6. Get the app URL

```bash
kubectl get ingress -n devboard-app
```

The `ADDRESS` column shows the ALB hostname once the controller finishes provisioning it (usually a couple of minutes). Open it in a browser over `http://` — no TLS listener is configured yet.

## IAM & add-ons

Both cluster add-ons use **IRSA**: a Kubernetes ServiceAccount assumes a scoped IAM role via the cluster's OIDC provider, so pods get exactly the AWS permissions they need without static credentials.

| | EBS CSI driver | AWS Load Balancer Controller |
|---|---|---|
| Purpose | Provisions EBS volumes for PVCs | Provisions ALBs for Ingress objects |
| IAM policy | Built into the Terraform module (`attach_ebs_csi_policy = true`) | Custom policy from AWS's published `iam_policy.json` |
| Installed via | `aws_eks_addon` (Terraform, AWS-managed) | `helm install` (community-maintained) |
| ServiceAccount | `kube-system:ebs-csi-controller-sa` | `kube-system:aws-load-balancer-controller` |
| Symptom if broken | PVC stuck `Pending` forever | Ingress has no `ADDRESS`, or ALB returns 503/504 |

This is a **one-time, per-cluster** setup — every additional `Ingress` or `PersistentVolumeClaim` created afterward reuses the same controllers automatically. A new cluster needs this bootstrap repeated once.

## Known issues / things to double-check

- **Node instance size matters.** `t3.micro` cannot run the EBS CSI controller pods alongside required system pods — it hits the per-node pod limit. Use `t3.medium` or larger.
- **`runAsNonRoot: true` requires a numeric `runAsUser`** if the Dockerfile's `USER` line names a user rather than a UID — otherwise Kubernetes refuses to start the container. Check with `docker run --rm <image> id <user>`.
- **Vite's `preview` server blocks unrecognized `Host` headers** (403 `Blocked request`) when served behind an ALB. Set `preview.allowedHosts: true` (or list the ALB hostname explicitly) in the Vite config actually used inside the Docker image — check for a separate Docker-specific Vite config file, not just the default `vite.config.js`.
- **`01-secrets-and-config.yaml`** currently has base64-looking values under `stringData`, which expects plaintext — fix before relying on real credentials (either use real plaintext values, or rename the field to `data`).
- **Label consistency** — standardize on `apps:` (not a mix of `app:`/`apps:`) across the Postgres StatefulSet and NetworkPolicies, or traffic will be silently blocked once policies are enforced.
- Application images are currently tagged `:latest` — consider pinning versions for predictable rollouts.
