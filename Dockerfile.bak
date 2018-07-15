FROM registry.saas.hand-china.com/tools/alpine:3.7-1

COPY justasite/ /myblog/

RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/gohugoio/hugo/releases/download/v0.44/hugo_0.44_Linux-64bit.tar.gz && \
  tar xzf hugo_0.44_Linux-64bit.tar.gz && \
  rm -r hugo_0.44_Linux-64bit.tar.gz && \
  mv hugo /usr/bin/hugo && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

WORKDIR myblog/

EXPOSE 1313

CMD hugo

CMD hugo server  --bind=0.0.0.0 -D