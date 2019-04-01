FROM cfbuildpacks/cflinuxfs3-cnb-experimental:base

RUN mkdir -p /workspace /layers /platform/env
RUN chown -R vcap:vcap /workspace /layers

ENV CNB_STACK_ID org.cloudfoundry.stacks.cflinuxfs3
ENV CNB_BUILDPACKS_DIR /buildpacks
ENV CNB_ORDER_PATH /buildpacks/order.toml
ENV CNB_GROUP_PATH ./group.toml
ENV CNB_PLAN_PATH ./plan.toml

USER vcap
