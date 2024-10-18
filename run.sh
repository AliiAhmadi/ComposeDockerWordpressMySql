#!/bin/bash

CHOICE="${1}"
LOG="/tmp/install.log"

if [[ -n "${DEBUG}" ]] && [[ "${DEBUG}" = "true" ]]; then
  LOG=/dev/stderr
fi

if ! docker info > /dev/null 2>&1; then
    echo "Docker service appears to not be running. Use the service command to start it manually."
    echo "$ sudo service docker start"
    exit 1
fi

if ! docker-compose version &> /dev/null; then
    echo "Docker Compose is not installed."
    exit 1
fi


status(){
    local total_expected_containers
    local actual_running_containers

    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    actual_running_containers="$(docker ps | grep -c wordpress)"

    if [[ "${actual_running_containers}" -ne "${total_expected_containers}" ]]; then
        echo "Service is down."
        echo "Expected: ${total_expected_containers}, Running: ${actual_running_containers}"
    else
        echo "Service is up."
    fi
}


teardown(){
    echo
    echo "==== Shutdown started ====" | tee -a $LOG
    docker-compose down --volumes
    echo "OK: Completed."
}

clean(){
    echo
    echo "==== Cleanup Started ===="
    docker-compose down --volumes --rmi all &> /dev/null &
    echo "Shutting down ..."
    wait "$!"

    docker system prune -a --volumes -f &> /dev/null &
    echo "Cleaning up ..."
    wait "$!"

    [[ -f "${LOG}" ]] && > "${LOG}"
    echo "OK: Completed."
}

deploy(){
    echo
    echo "==== Deployment Started ===="

    if [[ ! -f "./.env" ]]; then
        echo ".env file not exist. $ cp .env.example .env"
        exit 1
    fi


    echo "Deploying ..."
    docker-compose up -d
    echo "OK: Completed."
}

rebuild(){
    clean
    deploy
}

case "${CHOICE}" in
    deploy)
        deploy
    ;;
    teardown)
        teardown
    ;;
    clean)
        clean
    ;;
    rebuild)
        rebuild
    ;;
    status)
        status
    ;;
    *)
        echo "Usage: ./$(basename "$0") deploy | teardown | rebuild | clean | status"
    ;;
esac
