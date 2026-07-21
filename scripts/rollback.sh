#!/bin/bash

echo "Rolling back deployment..."

docker compose down

echo "Rollback completed."