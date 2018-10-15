FROM cfbuildpacks/cflinuxfs3-cnb-experimental:base

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=1s --start-period=60s --retries=1 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

ENV PACK_PROCESS_TYPE web

USER vcap

ENTRYPOINT ["/lifecycle/launcher"]
