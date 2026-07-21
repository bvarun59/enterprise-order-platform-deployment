#!/bin/bash

set -e

echo "Deploying Order Service..."

docker compose pull

docker compose up -d

echo "Deployment Complete."