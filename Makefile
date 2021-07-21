TARGETS := all

$(TARGETS):
	docker build -t longhornio/benchmark .
