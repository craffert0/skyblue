.PHONY: all regen lint

all: regen
	cd experiments/swift ; swift test
	cd experiments/swift ; swift build

CODEGEN_APP := codegen/.build/x86_64-apple-macosx/release/codegen
CODEGEN_FILES := $(shell find codegen/Sources -type f -name '*.swift') codegen/Package.swift

$(CODEGEN_APP): $(CODEGEN_FILES)
	cd codegen ; swift build --configuration release

regen: $(CODEGEN_APP)
	$(CODEGEN_APP) ../atproto/lexicons experiments/swift/Sources/Proto/generated

lint:
	tools/reformat.py
