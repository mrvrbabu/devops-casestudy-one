# From Alpine official image
FROM node:10.15.2-alpine

# Update apk repositories to be latest
RUN apk update

# Install git
RUN apk add git

# Install and config Supervisor
RUN apk add wget python py2-pip
RUN pip install --upgrade pip
RUN pip install wheel
RUN pip install supervisor supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install Nginx
RUN apk add nginx

# Override Nginx's default config
RUN rm -rf /etc/nginx/conf.d/default.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# Install app packages
##WORKDIR /app
WORKDIR /opt

# Add CWD
COPY ./app/src /opt/server/bin

# Start AdaptiveUI Application
WORKDIR /opt/server/bin

# Install Bash Shell
RUN apk add --update bash

# Clean up
RUN rm -rf /var/cache/apk/*

# Add a startup script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Expose Nginx port
EXPOSE 8080

# Run the startup script
WORKDIR /

CMD ["/start.sh"]
