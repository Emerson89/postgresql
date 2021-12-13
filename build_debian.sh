#!/bin/bash

DOCKER_CONTAINER_NAME="debian"
DOCKER_IMAGE="emr001/debian-emr"
INIT=/lib/systemd/systemd
RUN_OPTS="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"  

docker run -ti $RUN_OPTS --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE $INIT

docker exec $DOCKER_CONTAINER_NAME ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

docker exec -it $DOCKER_CONTAINER_NAME /bin/bash

docker stop $DOCKER_CONTAINER_NAME

docker rm $DOCKER_CONTAINER_NAME 