#!/bin/bash
set -e # ensure to exit on error

# Set your variables here
registry_name="bio0extcr"
repository_name="torch2.5.1cuda12.4"
image_tag="v1.0"  # Change this tag as needed

#AZ acr login
az acr login -n $registry_name

# Build the Docker image
echo "Building the Docker image..."
docker build . -f Dockerfile --progress=plain

# Get the Image ID of the most recently built image
image_id=$(docker images -q | head -n 1)

if [ -z "$image_id" ]; then
    echo "Error: Failed to get the image ID. The build might have failed."
    exit 1
fi

echo "Image built with ID: $image_id"

# Tag the image for pushing to ACR
echo "Tagging the Docker image..."
docker tag $image_id $registry_name.azurecr.io/$repository_name:$image_tag

# Push the image to ACR
echo "Pushing the image to Azure Container Registry (ACR)..."
docker push $registry_name.azurecr.io/$repository_name:$image_tag

echo "Image successfully pushed to ACR: $registry_name.azurecr.io/$repository_name:$image_tag"




