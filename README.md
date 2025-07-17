# datadog-with-redpanda
This repo has all the components required to setup datadog with redpanda in a docker environment.  

## start redpanda cluster
docker compose -f single-node-rp-cluster.yaml up -d

## build the image and push it to your private Docker registry.
docker build -t my-dd-rpd-agent:1.0 .

## OR use this command for logs during build
docker build --progress=plain --no-cache -t my-dd-rpd-agent:1.0 .

## verify the image is built
docker images | grep my-dd-rpd-agent

## start the ddagent-with-redpanda integration container 
docker run -d --name dd-agent \
-e DD_API_KEY=<your api key> \
-e DD_SITE="<datadog site>" \
-e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
-v /proc/:/host/proc/:ro \
-v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
-v /var/lib/docker/containers:/var/lib/docker/containers:ro \
my-dd-rpd-agent:1.0

## exec into datadog agent docker container
cp /etc/datadog-agent/conf.d/redpanda.d/conf.yaml.example /etc/datadog-agent/conf.d/redpanda.d/conf.yaml

## edit conf.yaml to include the correct hostname in openmetrics_endpoint.  
## In our case the redpanda docker hostname that is accessbile within another docker container
openmetrics_endpoint: http://host.docker.internal:9644/public_metrics

## restart the datadog agent container

## produce messages after creating a topic
rpk topic create test-topic
seq 1 100000 | rpk topic produce test-topic

