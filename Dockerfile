FROM hashicorp/terraform:light

WORKDIR /tf
COPY . /tf
RUN terraform init
