.PHONY: all regen lint

all:

regen:
	cd codegen ; swift run codegen ../../atproto/lexicons ../experiments/swift/Sources/Proto/generated

lint:
	tools/reformat.py
