FROM ubuntu:latest

MAINTAINER Ding Corporation

# install packages
RUN apt-get update \
    && apt-get install -y fetchmail maildrop mpack \
    && apt-get clean && rm -fr /var/lib/apt/lists/*

VOLUME /var/mail
VOLUME /config

RUN maildirmake /var/mail/working \
    && echo "to /var/mail/working" > /root/.mailfilter
TOUCH /var/mail/save-attachments.log

ADD save-attachments.crontab /etc/cron.d/save-attachments
ADD save-attachments.sh /opt/save-attachments.sh
RUN chmod 0644 /etc/cron.d/save-attachments

ADD docker-entrypoint.sh /opt/docker-entrypoint.sh
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD cron && tail -f /var/mail/save-attachments.log
