#!/bin/sh

# This scripts builds the image and pushes it to its Docker Hub repository

REPO=smarthelios/helm
TAG=$1

if [ "$#" != 1 ]; then
    echo "Missing tag for image. Usage: sh build-and-push.sh 1.2"
    exit
fi

docker build -t ${REPO}:${TAG} .

docker tag ${REPO}:${TAG}

docker push ${REPO}:${TAG}