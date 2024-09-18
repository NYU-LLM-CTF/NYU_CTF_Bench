FROM nginx:latest

ARG IDENTITY_HOST
ARG IDENTITY_PORT
ARG WEB_HOST
ARG WEB_PORT

COPY nginx-default.conf /etc/nginx/templates/default.conf.template
COPY ./images /usr/share/nginx/html/images/

EXPOSE 14180


CMD ["nginx", "-g", "daemon off;"]