if [ "$(docker ps -aq --filter name=ros_tf)" ]; then
    print_info "Detected running container instance. Attaching to the running container"
    docker exec -it ros_tf bash $@
    exit 0
fi

docker build -t ros_tf .
docker run --network=host --name=ros_tf -t -d ros_tf
#docker run --gpus all --network=host --name=ros_tf -t -d ros_tf

docker exec -it ros_tf bash
