#!/bin/bash

### In case the pre-run scripts create a healthcheck overwrite, it should be removed
if [[ "X${HEALTHCHECK_DIR}" != "X" ]] && [[ -f ${HEALTHCHECK_DIR}/force_true ]];then
    echo "> As a final step in the prerun, remove the force_true healthcheck"
    rm -f ${HEALTHCHECK_DIR}/force_true
fi
