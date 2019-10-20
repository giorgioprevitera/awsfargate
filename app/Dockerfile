FROM golang:1.13-stretch AS builder

COPY . /src

RUN cd /src \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/fargatetest \
    && chmod +x /go/bin/fargatetest

FROM scratch

COPY --from=builder /go/bin/fargatetest /go/bin/fargatetest

EXPOSE 8080

ENTRYPOINT ["/go/bin/fargatetest"]
