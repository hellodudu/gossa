FROM golang:1.18 as builder
COPY . /gossaSrc
ENV TZ Asia/Shanghai
ARG GOOS=linux
ARG GOARCH=amd64
RUN cd /gossaSrc && make build GOOS=$GOOS GOARCH=$GOARCH

FROM debian:10.13
ENV TZ Asia/Shanghai
ENV HOST="0.0.0.0" PORT="8001" PREFIX="/" FOLLOW_SYMLINKS="false" SKIP_HIDDEN_FILES="true" DATADIR="/shared" READONLY="false" VERB="false"
COPY ./support/entrypoint.sh /entrypoint.sh
COPY --from=builder /gossaSrc/gossa /gossa
ENTRYPOINT "/entrypoint.sh"
