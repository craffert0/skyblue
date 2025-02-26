.PHONY: all regen lint

all:

regen:
	tools/codegen.py -d ../atproto/lexicons -o experiments/swift/Sources/Proto/generated

lint:
	tools/reformat.py
