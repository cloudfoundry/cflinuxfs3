FROM golang:1.11.0 as builder

RUN go get github.com/buildpack/lifecycle
WORKDIR src/github.com/buildpack/lifecycle
RUN CGO_ENABLED=0 GO111MODULE=on go install -a -installsuffix static ./cmd/...

FROM cloudfoundry/cflinuxfs3:latest
LABEL io.buildpacks.stack.id="org.cloudfoundry.stacks.cflinuxfs3"

COPY --from=builder /go/bin /lifecycle

RUN mkdir -p /workspace/app /workspace/config /cache /platform/env
RUN chown -R vcap:vcap /workspace /cache

WORKDIR /workspace

