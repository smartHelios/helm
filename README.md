# smarthelios/helm

## Deployment to Curalie-prd EKS cluster

The `smarthelios/eks-kubectl` comes installed with `aws-iam-authenticator`, an AWS-vendored copy of `kubectl` and `helm`.

## Codeship Usage

### Generate a kubeconfig

```shell
aws eks --region eu-west-1 update-kubeconfig --name <cluster-name> --kubeconfig <destination>
# export KUBECONFIG=<above-destination> in your ~/.bashrc first
kubectl config view --flatten > kubeconfigdata
```

### Copy contents to env var file using our codeship/env-var-helper container

```shell
docker run --rm -it -v $(pwd):/files codeship/env-var-helper cp kubeconfigdata:/root/.kube/config k8s-env
```

Check out the [codeship/env-var-helper README](https://github.com/codeship-library/docker-utilities/tree/master/env-var-helper) for more information.

### Encrypt the file, remove files and/or add to `.gitignore`

```shell
jet encrypt k8s-env k8s-env.encrypted
rm kubeconfigdata k8s-env
```

### Configure the service and steps into the build with the following as guidance

```shell
# codeship-services.yml

kubectl:
  build:
    image: smarthelios/helm:prd
    dockerfile: Dockerfile
  encrypted_env_file: k8s-env.encrypted
```

```shell
# codeship-steps.yml

- name: check response to kubectl config
  service: helm
  command: helm list --all
```

## Notice

This container is inspired by and based on the [codeship kubectl container](https://github.com/codeship-library/kubectl)