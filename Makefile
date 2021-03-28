help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

start: ## Start a new container
	# Make a new PID namespace and run bash in it
	# Need to `--fork` a new child process to run the program in its new "unshared" namespace
	# Need to `--mount-proc`
	sudo unshare --pid --fork --mount-proc bash
