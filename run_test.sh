#!/bin/bash

if [[ $1 = "setup" ]]; then
    python3 -m venv ~/venv
    . ~/venv/bin/activate

    pip install --upgrade pip setuptools
    pip install dbt

    sudo apt-get update && sudo apt-get install -y libsasl2-modules libsasl2-dev
    pip install dbt-spark

    mkdir -p ~/.dbt
    cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml
else
    . ~/venv/bin/activate
    cd integration_tests
    dbt deps --target $1
    dbt seed --target $1 --full-refresh
    dbt run --target $1
    dbt test --target $1
fi