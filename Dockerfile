FROM ruby:2.3.1-slim

RUN apt-get update && apt-get install -y curl git ssh jq zip

ARG HELM_VERSION="3.6.3"

# install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

# awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&  unzip awscliv2.zip && ./aws/install

COPY env_var_helper_client.sh env_var_helper_client.rb ./
RUN chmod +x env_var_helper_client.sh

ENTRYPOINT ["./env_var_helper_client.sh"]