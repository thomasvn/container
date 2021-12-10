help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the bloated container image
	- docker rmi example:bloat
	docker build -t example:bloat .

build-squash: ## Build the squashed container image
	- docker rmi example:squash
	docker build -t example:squash --squash .

run: ## Run the container image
	make build
	docker run -it --rm example:bloat bash