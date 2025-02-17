.PHONY: all regen lint

all:

regen:
	tools/codegen.py -d ../atproto/lexicons -o generated

lint:
	tools/reformat.py
