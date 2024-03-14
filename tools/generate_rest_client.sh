#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(pwd)/$(dirname "$0")/../"

cd $(mktemp -d)

git clone -b chrono-latest --sparse --filter=blob:none --depth=1 https://github.com/qdrant/qdrant
cd qdrant
git sparse-checkout add docs/redoc/master

OPENAPI_PATH="$(pwd)/docs/redoc/master/openapi.json"

cd $(mktemp -d)

git clone https://github.com/qdrant/pydantic_openapi_v3
cd pydantic_openapi_v3

poetry install

cp $OPENAPI_PATH openapi-qdrant.yaml

PATH_TO_QDRANT_CLIENT=$PROJECT_ROOT

INPUT_YAML=openapi-qdrant.yaml IMPORT_NAME="qdrant_client.http" PACKAGE_NAME=qdrant_openapi_client bash -x scripts/model_data_generator.sh

rm -rf ${PATH_TO_QDRANT_CLIENT}/qdrant_client/http/
mv scripts/output/qdrant_openapi_client ${PATH_TO_QDRANT_CLIENT}/qdrant_client/http/
