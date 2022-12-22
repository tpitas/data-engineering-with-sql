#!/bin/bash

if [ "${environment}" = "dev" ]; then
    db_host="pitasare"
    db_name="pita"
    base_file="dev_dental"
else
    db_host="labesare"
    db_name="labe_${environment}"
    base_file="test_dental"
fi
