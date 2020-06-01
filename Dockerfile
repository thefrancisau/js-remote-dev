FROM ubuntu:20.04
MAINTAINER Francis Au <thefrancisau@gmail.com>

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  curl \
  git \
  openssh-server \
  sudo \
  tzdata

# install node v12
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt install -y nodejs

RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Create a sudo user
RUN adduser dev
RUN usermod -aG sudo dev
RUN echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /home/dev/.ssh && mkdir /home/dev/secret && mkdir /home/dev/jscode
RUN chown dev:dev -R /home/dev

EXPOSE 22
EXPOSE 3000
CMD ["/usr/sbin/sshd","-D"]
