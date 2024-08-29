FROM ubuntu:14.04.3

#Dont start slapd on install
RUN echo "#!/bin/sh\nexit 101" >/usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

RUN apt-get update \
    && apt-get install -y php5 php5-ldap ldap-utils slapd apache2 supervisor

env LDAP_ROOTPASS toor
env LDAP_ORGANISATION Any Comp.
env LDAP_DOMAIN any.comp

RUN mkdir -p /var/log/supervisord

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ldap.conf /etc/ldap/ldap.conf
COPY start_slapd /usr/bin/start_slapd
ADD users.ldif /opt
ADD htdocs/* /var/www/html

RUN chmod +x /usr/bin/start_slapd
RUN rm /var/www/html/index.html

EXPOSE 389 80

#RUN ldapmodify -h localhost -p 389 -a -D "cn=admin,dc=any,dc=comp" -w toor -f opt/users.ldif

CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf