FROM golang:1.11.0 as builder

RUN go get github.com/buildpack/lifecycle
WORKDIR src/github.com/buildpack/lifecycle
RUN CGO_ENABLED=0 GO111MODULE=on go install -a -installsuffix static ./cmd/...

FROM cloudfoundry/cflinuxfs3:latest

LABEL io.buildpacks.stack.id="org.cloudfoundry.stacks.cflinuxfs3"
ENV PACK_STACK_ID org.cloudfoundry.stacks.cflinuxfs3
ENV PACK_BUILDPACKS_DIR /buildpacks
ENV PACK_ORDER_PATH /buildpacks/order.toml
ENV PACK_GROUP_PATH ./group.toml
ENV PACK_PLAN_PATH ./plan.toml

COPY --from=builder /go/bin /lifecycle
WORKDIR /workspace