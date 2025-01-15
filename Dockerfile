FROM alpine:latest

ARG TARGETARCH

COPY cpu_arch.$TARGETARCH /cpu_arch

RUN chmod +x /cpu_arch

CMD ["/cpu_arch"]
