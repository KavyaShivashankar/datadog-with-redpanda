FROM gcr.io/datadoghq/agent:latest

ARG INTEGRATION_VERSION=2.1.0

RUN agent integration install -r -t datadog-redpanda==${INTEGRATION_VERSION}:wq!
