#!/bin/bash
TOP=$(pwd)
mkdir -p $TOP/docs/build	
DOCS_BUILD_DIR=$TOP/docs/build
ALL_RST_FILES_UNSORTED=$(find docs modules -name "*.rst")
ALL_RST_FILES=$(echo "$ALL_RST_FILES_UNSORTED" | tr ' ' '\n' | sort)
BUILD_RST_FILES_UNSORTED=$(find $DOCS_BUILD_DIR -name "*.rst")
BUILD_RST_FILES=$(echo "$BUILD_RST_FILES_UNSORTED" | tr ' ' '\n' | sort)
SRC_RST_FILES=$(comm -3 <(echo "$BUILD_RST_FILES") <(echo "$ALL_RST_FILES"))
sphinx-build -b html -c ./docs/ docs $TOP/build/html