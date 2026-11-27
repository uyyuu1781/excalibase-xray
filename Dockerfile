FROM ghcr.io/xtls/xray-core:latest AS src
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=src /usr/local/bin/xray /usr/local/bin/xray
COPY --from=src /usr/local/share/xray /usr/local/share/xray
ENV XRAY_LOCATION_ASSET=/usr/local/share/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/xray
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["/entrypoint.sh"]
