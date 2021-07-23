TARGETS := all

$(TARGETS):
	docker build -t yasker/benchmark .
