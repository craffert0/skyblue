# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: codegen

all: test experiments

test: test_experiments test_codegen test_schema

lint:
	tools/reformat.py

## Build and test the codegen app.

CODEGEN_APP := codegen/.build/release/codegen
CODEGEN_FILES := $(shell find codegen/Sources -type f -name '*.swift') codegen/Package.swift

$(CODEGEN_APP): $(CODEGEN_FILES)
	cd codegen ; swift build --configuration release

test_codegen:
	cd codegen ; swift test

## Generate code from atproto

LEXICON_DIR := ../atproto/lexicons

GENERATION_DIR := main/Schema/Sources/Schema/Generated
GENERATION_ENUM := $(GENERATION_DIR)/TopEnum.swift

$(GENERATION_ENUM): $(CODEGEN_APP)
	$(CODEGEN_APP) $(LEXICON_DIR) $(GENERATION_DIR)

codegen: $(GENERATION_ENUM)

## Test the Schema 

SCHEMA_MODULE := main/Schema/.build/debug/Schema.build/Schema.emit-module.d
SCHEMA_FILES := $(shell find main/Schema/Sources -type f -name '*.swift') main/Schema/Package.swift
$(SCHEMA_MODULE): $(SCHEMA_FILES) $(GENERATION_ENUM)
	cd main/Schema ; swift build

test_schema: $(GENERATION_ENUM)
	cd main/Schema ; swift test

## Build and test the experiments app

EXPERIMENTS_APP := experiments/swift/.build/debug/Main
EXPERIMENTS_FILES := $(shell find experiments/swift/Sources -type f -name '*.swift') experiments/swift/Package.swift

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
