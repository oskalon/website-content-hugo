FROM ubuntu:latest AS builder
RUN apt-get update -y;
RUN apt-get install curl git -y;
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.110.0/hugo_extended_0.110.0_linux-amd64.deb -o hugo.deb;
RUN apt install ./hugo.deb;

WORKDIR /website
COPY . .

RUN hugo

FROM nginx:1.17.8-alpine
COPY nginx/default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /website/public/ /usr/share/nginx/html
RUN chown nginx:nginx /usr/share/nginx/html/*
