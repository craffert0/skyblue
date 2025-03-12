.PHONY: codegen

all: test experiments

test: test_experiments test_codegen

lint:
	tools/reformat.py

## Build and test the codegen app.

CODEGEN_APP := codegen/.build/x86_64-apple-macosx/release/codegen
CODEGEN_FILES := $(shell find codegen/Sources -type f -name '*.swift') codegen/Package.swift

$(CODEGEN_APP): $(CODEGEN_FILES)
	cd codegen ; swift build --configuration release

test_codegen:
	cd codegen ; swift test

## Generate code from atproto

LEXICON_DIR := ../atproto/lexicons

GENERATION_DIR := experiments/swift/Sources/Proto/generated
GENERATION_ENUM := $(GENERATION_DIR)/TopEnum.swift

$(GENERATION_ENUM): $(CODEGEN_APP)
	$(CODEGEN_APP) $(LEXICON_DIR) $(GENERATION_DIR)

codegen: $(GENERATION_ENUM)

## Build and test the experiments app

EXPERIMENTS_APP := experiments/swift/.build/debug/Main
EXPERIMENTS_FILES := $(shell find experiments/swift/Sources -type f -name '*.swift') experiments/swift/Package.swift

experiments: $(EXPERIMENTS_APP)

$(EXPERIMENTS_APP): $(EXPERIMENTS_FILES) $(GENERATION_ENUM)
	cd experiments/swift ; swift build

test_experiments: $(GENERATION_ENUM)
	cd experiments/swift ; swift test

experiment_prefs: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) prefs ~/.skybluerc

experiment_author: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) author ~/.skybluerc

experiment_timeline: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) timeline ~/.skybluerc
