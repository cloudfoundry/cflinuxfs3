FROM cloudfoundry/cnb-base:cflinuxfs3

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=1s --start-period=60s --retries=1 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

ENV CNB_PROCESS_TYPE web

USER vcap

ENTRYPOINT ["/lifecycle/launcher"]
