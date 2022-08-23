FROM alpine:3.16.2

ENV ANSIBLE_VERSION=2.13.3
ENV ANSIBLE_LINT_VERSION=4.2.0

#RUN apk update \
#  && apk add --no-cache --progress python3 openssl \
#  ca-certificates git openssh sshpass \
#  && apk --update add --virtual build-dependencies \
#  python3-dev libffi-dev openssl-dev build-base bash \
#  && rm -rf /var/cache/apk/* 
RUN apk update \
 && apk add --no-cache --progress py3-pip openssl \
 ca-certificates git openssh sshpass \
 && apk --update add --virtual build-dependencies \
 libffi-dev openssl-dev build-base bash \
 && rm -rf /var/cache/apk/* && pip3 install --upgrade pip \
 && pip3 install ansible-core==${ANSIBLE_VERSION} 
 #\
 #&& pip3 install ansible-lint==${ANSIBLE_LINT_VERSION}
