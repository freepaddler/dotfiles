FROM alpine:latest
RUN apk add --update --no-cache curl bash
WORKDIR /root
RUN curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
ENV PATH=${PATH}:/root/yandex-cloud/bin
ENTRYPOINT ["yc"]