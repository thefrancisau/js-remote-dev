# js-remote-dev
Javascript Remote Development Server for Visual Studio Code

## Javascript Remote Development Server for Visual Studio Code

### The container image is to deploy a remote development server for Javascript development on your local machine on your remote docker host.

### Base Image and Tag

  - The base image is ubuntu:20.04 and tag of image is the version of nodejs included on the image.

### Instructions for deployment:

  - On your workstation: 

    * Install supported ssh client. [Check here](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client)
  
  - On your remote docker host:

    * copy your public key (id_rsa.pub) from your workstation to your dockerhost.

    * create 'secret' and 'jscode' volumes.  
```
    docker volume create secret
    docker volume create jscode
```

  * build a new docker container as your remote development server
```
  docker run -d \
    --name js-dev \
    --mount source=secret,target=/home/dev/secret \
    --mount source=code,target=/home/dev/jscode \
    --hostname js-dev \
    -p 4022:22 \
    -p 3000:3000 \
    francisau:js-remote-dev
```

  * copy your public key and environment secrets to the container
```
  docker cp id_rsa.pub js-dev:/home/dev/.ssh/authorized_keys
  docker exec -d js-dev bash -c "chown dev:dev -R /home/dev/"
  docker cp .env js-dev:/home/dev/secret
```

## Instructions for usage:

- On your workstation: 
  
  * Getting started on Remote development over SSH. [Check here](https://code.visualstudio.com/remote-tutorials/ssh/getting-started)
  
  * after ssh into the remote server, the user is 'dev', which is a 'sudo' user without a password. 

  * test ssh to the container from your workstation
```
   ssh -p 4022 dev@<dockerhost>
```

 * if the container cannot be reached, check if firewall rule to allow the port 4022 of dockerhost is set.

* if password is asked, check the ownership and content of /home/dev/authorized-keys inside the container.
 

  * curl, git, nodejs are installed on the remote server, check the node version
```
  node -v
  git --version
```

  * use jscode directory, and git clone into it
```
  cd ~/jscode
  git clone ...
```
  
 
