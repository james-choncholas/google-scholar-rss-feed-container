# Variables
IMAGE_NAME = google-scholar-rss-feed
CONTAINER_NAME = google-scholar-rss-feed
DOCKERFILE = Dockerfile
REGISTRY = reg.choncholas.com
REPOSITORY = docker/$(IMAGE_NAME)
TAG = latest

# Default target
.PHONY: all
all: build

# Build the Docker image
.PHONY: build
build:
	@echo "Building Docker image $(IMAGE_NAME)..."
	docker build -t $(IMAGE_NAME) -f $(DOCKERFILE) .

# Tag the image for pushing
.PHONY: tag
tag: build
	@echo "Tagging image as $(REGISTRY)/$(REPOSITORY):$(TAG)..."
	docker tag $(IMAGE_NAME) $(REGISTRY)/$(REPOSITORY):$(TAG)

# Push the image to registry
.PHONY: push
push: tag
	@echo "Pushing image to $(REGISTRY)/$(REPOSITORY):$(TAG)..."
	docker push $(REGISTRY)/$(REPOSITORY):$(TAG)

# Run the container
.PHONY: run
run:
	@echo "Running container $(CONTAINER_NAME)..."
	docker run -p 3005:3005 --name $(CONTAINER_NAME) $(IMAGE_NAME)

# Stop the container
.PHONY: stop
stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	docker stop $(CONTAINER_NAME) || true
	@echo "Removing container $(CONTAINER_NAME)..."
	docker rm $(CONTAINER_NAME) || true

# Run the container with interactive shell
.PHONY: shell
shell:
	@echo "Starting container with interactive shell..."
	docker run -p 3005:3005 -it --rm $(IMAGE_NAME) /bin/bash

# Clean up (remove container and image)
.PHONY: clean
clean:
	@echo "Cleaning up..."
	-docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-docker rm $(CONTAINER_NAME) 2>/dev/null || true
	-docker rmi $(IMAGE_NAME) 2>/dev/null || true
	-docker rmi $(REGISTRY)/$(REPOSITORY):$(TAG) 2>/dev/null || true

# Help command
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make build  - Build the Docker image"
	@echo "  make tag	- Tag the image for the registry"
	@echo "  make push   - Push the image to the registry"
	@echo "  make run	- Run the container"
	@echo "  make shell  - Run container with interactive shell"
	@echo "  make clean  - Remove container and image"
	@echo "  make help   - Show this help message"