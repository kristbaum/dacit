FROM nginx:stable-alpine

WORKDIR /dacit/dacit
RUN apk add --update npm
RUN pwd
COPY /dacit/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]