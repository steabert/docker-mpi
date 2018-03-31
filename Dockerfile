FROM alpine:edge
RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --no-cache bash
RUN apk add --no-cache openmpi-dev
RUN apk add --no-cache openssh
RUN ssh-keygen -A
RUN echo "LogLevel DEBUG" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN apk add --no-cache shadow
RUN adduser -D mpi
RUN usermod -p '*' mpi
USER mpi
WORKDIR /home/mpi
RUN mkdir .ssh/ && chmod 700 .ssh/
RUN ssh-keygen -t rsa -f .ssh/id_rsa -N ''
RUN cat .ssh/id_rsa.pub > .ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" > .ssh/config
RUN chmod 600 .ssh/*
USER root
EXPOSE 22
ENTRYPOINT [ "/usr/sbin/sshd", "-De" ]
