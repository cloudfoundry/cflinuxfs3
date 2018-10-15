FROM cfbuildpacks/cflinuxfs3-cnb-experimental:base

RUN mkdir -p /workspace/app /workspace/config /cache /platform/env
RUN chown -R vcap:vcap /workspace /cache

ENV PACK_STACK_ID org.cloudfoundry.stacks.cflinuxfs3
ENV PACK_BUILDPACKS_DIR /buildpacks
ENV PACK_ORDER_PATH /buildpacks/order.toml
ENV PACK_GROUP_PATH ./group.toml
ENV PACK_PLAN_PATH ./plan.toml

USER vcap