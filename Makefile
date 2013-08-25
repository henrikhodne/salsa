NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

all:
	@mkdir -p bin/
	@echo "${OK_COLOR}==> Building${NO_COLOR}"
	@./scripts/build.sh

clean:
	@rm -rf bin/ pkg/

format:
	go fmt ./...

.PHONY: all clean format
