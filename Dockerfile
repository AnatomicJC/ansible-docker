FROM python:3.8-alpine as build

ARG ANSIBLE_VERSION=2.9.7
# Inspired from https://github.com/William-Yeh/docker-ansible

RUN apk upgrade --no-cache \
 && echo "===> Installing sudo to emulate normal OS behavior..." \
 && apk --update add sudo \
 && apk --update add --virtual build-dependencies python3-dev libffi-dev openssl-dev build-base \
 && pip3 install --user --upgrade pip cffi \
 && echo "===> Installing Ansible..." \
 && pip3 install --user ansible==${ANSIBLE_VERSION} ansible-lint \
 && echo "===> Installing handy tools (not absolutely required)..." \
 && pip3 install --user --upgrade pycrypto pywinrm \
 && pip3 install --user --upgrade pyotp \
 # this for kubespray
 && pip3 install --user --upgrade netaddr pbr hvac jmespath \
 && echo "===> Removing package list..." \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* \
 && echo "===> Adding hosts for convenience..." \
 && mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts

RUN find /root/.local -name "*pyc" \
                   -o -name "*pyo" \
                   -o -name "*dist-info" \
                   -o -name "tests" | xargs rm -rf
FROM python:3.8-alpine

RUN adduser -D -u 1000 ansible

COPY --from=build --chown=ansible:ansible /root/.local/ /home/ansible/.local/
COPY --chown=ansible:ansible zshrc /home/ansible/.zshrc

RUN apk upgrade --no-cache \
 && mkdir -p /etc/ansible \
 && mkdir -p /home/ansible/.ssh/sockets \
 && chown -R ansible:ansible /home/ansible/.ssh \
 && apk add sshpass openssh-client rsync zsh bash git curl unzip tar \
 && echo 'localhost' > /etc/ansible/hosts \
 && wget https://github.com/robbyrussell/oh-my-zsh/archive/master.zip \
 && unzip master.zip \
 && mv ohmyzsh-master /home/ansible/.oh-my-zsh \
 && rm master.zip \
 && wget https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.zip \
 && unzip master.zip \
 && mv zsh-syntax-highlighting-master /home/ansible/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
 && rm master.zip \
 && chown -R ansible:ansible /home/ansible/.oh-my-zsh \
 && find /home/ansible/.oh-my-zsh -type d | xargs chmod 755 \
 && find /home/ansible/.oh-my-zsh -type f -name "*md" | xargs rm

USER ansible
WORKDIR /home/ansible

ENV PATH=${PATH}:/home/ansible/.local/bin

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
