FROM ubuntu:18.04
RUN echo "Ubuntu 18.04"
ENV DEBIAN_FRONTEND noninteractive
# Setup ENV for systemd
ENV container docker

#enable source package repos
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

#update and upgrade
RUN apt-get update
RUN apt-get upgrade -y

#install utilities and dependencies
RUN apt-get install apt-utils dpkg-dev net-tools iputils-ping -y
RUN apt-get install build-essential vim help2man autotools-dev autoconf -y
RUN apt-get install inetutils-inetd inetutils-telnetd -y
RUN apt-get install systemd systemd-sysv -y

#hack /etc/pam.d/login to disable pam_securetty
RUN sed -i 's/auth \[success\=ok new_authtok_reqd\=ok ignore\=ignore user_unknown\=bad default\=die\] pam_securetty.so/#auth \[success\=ok new_authtok_reqd\=ok ignore\=ignore user_unknown\=bad default\=die\] pam_securetty.so/g' /etc/pam.d/login

#RUN echo "telnet                  stream  tcp     nowait  root    /usr/local/libexec/telnetd      telnetd" >> /etc/inetd.conf
RUN echo "telnet                  stream  tcp     nowait  root    /usr/sbin/telnetd      telnetd" >> /etc/inetd.conf

VOLUME [ "/sys/fs/cgroup" ]

# Finished!
RUN echo 'Container is ready, run it using $ sudo docker run -d --name systemdubuntuserverenv --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --network host tsystemdubuntuserverenv:latest'
RUN echo 'Then attach to it using $ sudo docker exec -it systemdubuntuserverenv bash'

RUN mkdir -p /usr/local/src/privoxy/
WORKDIR /usr/local/src/privoxy/
COPY build_privoxy.sh privoxy.sh
RUN chmod +x privoxy.sh

RUN ./privoxy.sh


ADD privoxy-start.sh /usr/local/bin/
ADD config /etc/privoxy/

