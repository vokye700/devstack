#!/bin/bash

set -e
set -x

if [[ $DEVSTACK == 'lms' ]]; then
    make dev.provision          &&
    make dev.up                 &&
    sleep 60                    &&  # LMS needs like 60 seconds to come up
    make healthchecks           &&
    make validate-lms-volume    &&
                                    # Disable e2e-tests until either:
                                    # * tests are less flaky
                                    # * We have a way to test the infrastructure for testing but ignore the test results.
                                    # See PLAT-1712
                                    # - make e2e-tests
    make up-marketing-detached
fi

if [[ $DEVSTACK == 'analytics_pipeline' ]]; then
    make dev.provision.analytics_pipeline   &&
    make stop.all                           &&
    make dev.up.analytics_pipeline          &&
    sleep 15 && # hadoop services need sometime to be fully functional and out of safemode
    make analytics-pipeline-devstack-test
fi