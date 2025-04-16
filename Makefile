# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: codegen

all: test experiments top

test: test_experiments test_codegen test_schema test_skyblueapi

lint:
	tools/reformat.py

## Build and test the codegen app.

CODEGEN_APP := codegen/.build/release/codegen
CODEGEN_FILES := $(shell find codegen/Sources -type f -name '*.swift') codegen/Package.swift

$(CODEGEN_APP): $(CODEGEN_FILES)
	cd codegen ; swift build --configuration release

## Generate code from test_lexicon

TEST_LEXICON_DIR := test_lexicon
TEST_LEXICON_FILES := $(shell find $(TEST_LEXICON_DIR) -type f)

TEST_GENERATION_DIR := codegen/Tests/Generated
TEST_GENERATION_ENUM := $(TEST_GENERATION_DIR)/TopEnum.swift

$(TEST_GENERATION_ENUM): $(CODEGEN_APP) $(TEST_LEXICON_FILES)
	$(CODEGEN_APP) $(TEST_LEXICON_DIR) $(TEST_GENERATION_DIR)

codegen: $(TEST_GENERATION_ENUM)

test_codegen: $(TEST_GENERATION_ENUM)
	cd codegen ; swift test

## Generate code from atproto

LEXICON_DIR := ../atproto/lexicons

GENERATION_DIR := main/Schema/Sources/Schema/Generated
GENERATION_ENUM := $(GENERATION_DIR)/TopEnum.swift

$(GENERATION_ENUM): $(CODEGEN_APP)
	$(CODEGEN_APP) $(LEXICON_DIR) $(GENERATION_DIR)

codegen: $(GENERATION_ENUM)

test_skyblueapi:
	cd main/BlueSkyApi ; swift test

## Test the Schema 

SCHEMA_MODULE := main/Schema/.build/debug/Schema.build/Schema.emit-module.d
SCHEMA_FILES := $(shell find main/Schema/Sources -type f -name '*.swift') main/Schema/Package.swift
$(SCHEMA_MODULE): $(SCHEMA_FILES) $(GENERATION_ENUM)
	cd main/Schema ; swift build

test_schema: $(GENERATION_ENUM)
	cd main/Schema ; swift test

## Build and test the experiments app

EXPERIMENTS_APP := experiments/swift/.build/debug/Main
EXPERIMENTS_FILES := $(shell find experiments/swift/Sources/Main -type f -name '*.swift') experiments/swift/Package.swift

experiments: $(EXPERIMENTS_APP)

$(EXPERIMENTS_APP): $(EXPERIMENTS_FILES) $(SCHEMA_MODULE)
	cd experiments/swift ; swift build

test_experiments: $(SCHEMA_MODULE)
	cd experiments/swift ; swift test

experiment_prefs: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) prefs ~/.skybluerc

experiment_author: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) author ~/.skybluerc

experiment_timeline: $(EXPERIMENTS_APP)
	$(EXPERIMENTS_APP) timeline ~/.skybluerc

TOP_APP := experiments/swift/.build/debug/Top
TOP_FILES := $(shell find experiments/swift/Sources/Top -type f -name '*.swift') experiments/swift/Package.swift

top: $(TOP_APP)

top10: $(TOP_APP)
	$(TOP_APP) ~/Documents/cursed/top10.json

top100: $(TOP_APP)
	$(TOP_APP) ~/Documents/cursed/top100.json

top1000: $(TOP_APP)
	$(TOP_APP) ~/Documents/cursed/top1000.json

$(TOP_APP): $(TOP_FILES) $(SCHEMA_MODULE)
	cd experiments/swift ; swift build
