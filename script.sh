#!/bin/bash
TOP=$(pwd)
mkdir -p $TOP/docs/build	
sphinx-build -b html -c ./docs/ docs $TOP/build/html
