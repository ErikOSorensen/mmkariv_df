#!/bin/bash
docker run --rm -ti -v /usr/local/stata17/stata.lic:/usr/local/stata/stata.lic \
    -v ${PWD}:/code --entrypoint stata-se dataeditors/stata17:2022-11-15 \
    -b do scripts/all_data_reads.do
