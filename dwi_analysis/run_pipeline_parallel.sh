#!/bin/bash

# generate commands with temporal_phase=3 for experimentation
./generate_parallel_commands.sh 3

# then run with GNU parallel
parallel --jobs 4 --delay 300 --joblog full_log.txt < full_pipeline_commands.txt
