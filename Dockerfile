FROM ubuntu:latest AS builder
RUN apt-get update -y;
RUN apt-get install curl git -y;
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.91.2/hugo_0.91.2_Linux-64bit.deb -o hugo.deb;
RUN apt install ./hugo.deb;

WORKDIR /website
COPY . .

RUN hugo

FROM nginx:1.17.8-alpine
COPY nginx/default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /website/public/ /usr/share/nginx/html

