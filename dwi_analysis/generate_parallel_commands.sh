#!/bin/bash

###############################################################################
# write GNU parallel commands for dMRI pipeline (for SDflex)
# adapted from hartmut's code!
#
# Usage:
#   ./generate_parallel_commands.sh [temporal_phase_value]
#
# Arguments:
#   temporal_phase_value  Optional: 1, 2, or 3 (default: 3)
#                         Controls NORDIC phase correction aggressiveness
#
# Output:
#   - nordic_commands.txt: Commands for NORDIC denoising step
#   - pipeline_commands.txt: Commands for post-NORDIC pipeline
#   - full_pipeline_commands.txt: Commands for complete pipeline (both steps)
#
# 20260127: alex
# 20260129: alex: added temporal_phase_value, fixed paths to match wrapper
# ###############################################################################

set -e

###############################################################################
# config: MUST!!!! MATCH!!!!! ENGRAMS_full_pipeline_wrapper.sh
###############################################################################

BASE_DIR="/mnt/work/yiy/ENGRAMS"
SCRIPTS_DIR="${BASE_DIR}/scripts"

# NORDIC config (match the details in wrapper)
USE_COMPILED=1
MCR_PATH="/mnt/work/yiy/ENGRAMS/scripts/MATLAB_Runtime_R2022a_Update_9_glnxa64/v912"
COMPILED_NORDIC="${SCRIPTS_DIR}/compiled/run_ENGRAMS_denoise_NORDIC_compiled.sh"

# NORDIC temporal phase input 
# (for now just use 3, there's no apparent difference in the results)
DEFAULT_TEMPORAL_PHASE=3

# list of subjs (one ID per line)
SUBJECT_LIST="${SCRIPTS_DIR}/subjects.txt"

# output command files
NORDIC_COMMANDS="${SCRIPTS_DIR}/nordic_commands.txt"
PIPELINE_COMMANDS="${SCRIPTS_DIR}/pipeline_commands.txt"
FULL_COMMANDS="${SCRIPTS_DIR}/full_pipeline_commands.txt"

###############################################################################
# parse args
###############################################################################

TEMPORAL_PHASE="${1:-${DEFAULT_TEMPORAL_PHASE}}"

# check and validate temporal_phase_value
if [[ ! "${TEMPORAL_PHASE}" =~ ^[123]$ ]]; then
    echo "error: temporal_phase_value must be 1, 2, or 3 (got: ${TEMPORAL_PHASE})"
    exit 1
fi

###############################################################################
# check inputs
###############################################################################

if [ ! -f "${SUBJECT_LIST}" ]; then
    echo "subject list not found: ${SUBJECT_LIST}"
    echo ""
    echo "make a file with one subject ID per line, e.g.:"
    echo "  sub-105v1s1"
    echo "  sub-207v1s1"
    echo "  sub-301v1s1"
    exit 1
fi

echo "***************************************************************"
echo "gen GNU Parallel commands"
echo "***************************************************************"
echo ""
echo "Base directory: ${BASE_DIR}"
echo "Subject list: ${SUBJECT_LIST}"
echo "Number of subjects: $(wc -l < ${SUBJECT_LIST})"
echo "Temporal phase value: ${TEMPORAL_PHASE}"
echo ""

###############################################################################
# write NORDIC commands
###############################################################################

echo "writing NORDIC commands..."
> "${NORDIC_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    # skip empty lines and comments
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    if [ ${USE_COMPILED} -eq 1 ]; then
        echo "${COMPILED_NORDIC} ${MCR_PATH} ${SUBJECT} ${BASE_DIR} ${TEMPORAL_PHASE}" >> "${NORDIC_COMMANDS}"
    else
        echo "matlab batch mode is only possible on hydra... turn back"
    fi
    
done < "${SUBJECT_LIST}"

echo "  written: ${NORDIC_COMMANDS}"
echo "  commands: $(wc -l < ${NORDIC_COMMANDS})"

###############################################################################
# write post-NORDIC pipeline commands
###############################################################################

echo "writing pipeline commands..."
> "${PIPELINE_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    echo "${SCRIPTS_DIR}/ENGRAMS_DWIpipeline_postNORDIC_SDflex.sh ${SUBJECT}" >> "${PIPELINE_COMMANDS}"
    
done < "${SUBJECT_LIST}"

echo "  written: ${PIPELINE_COMMANDS}"
echo "  commands: $(wc -l < ${PIPELINE_COMMANDS})"

###############################################################################
# write full pipeline commands (wrapper that does both)
###############################################################################

echo "writing full pipeline commands..."
> "${FULL_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    # pass $temporal_phase_value to wrapper
    echo "${SCRIPTS_DIR}/ENGRAMS_full_pipeline_wrapper.sh ${SUBJECT} ${TEMPORAL_PHASE}" >> "${FULL_COMMANDS}"
    
done < "${SUBJECT_LIST}"

echo "  written: ${FULL_COMMANDS}"
echo "  commands: $(wc -l < ${FULL_COMMANDS})"

###############################################################################
# print usage instructions in case someone else wants to use this
###############################################################################

N_SUBJECTS=$(wc -l < ${SUBJECT_LIST})

echo ""
echo "***************************************************************"
echo "how do you use this script?"
echo "***************************************************************"
echo ""
echo "opt 1: run NORDIC and pipeline separately (for debugging)"
echo ""
echo "  step 1-1: run NORDIC on all subjects:"
echo "    parallel --jobs 4 --delay 300 --joblog nordic_log.txt < ${NORDIC_COMMANDS}"
echo ""
echo "  setp 1-2: run post-NORDIC pipeline on all subjects:"
echo "    parallel --jobs 4 --delay 60 --joblog pipeline_log.txt < ${PIPELINE_COMMANDS}"
echo ""
echo "opt 2: run full pipeline in one go"
echo ""
echo "    parallel --jobs 4 --delay 300 --joblog full_log.txt < ${FULL_COMMANDS}"
echo ""
echo "----------------------------------------------------------------------"
echo "tips on parallelisation (hartmut's advice):"
echo ""
echo "  - SDFlex has 224 threads; use max 100 at a time"
echo "  - each job uses OMP_NUM_THREADS=24 internally"
echo "  - dleay prevents I/O contention when accessing data"
echo ""
echo "  recommended settings for ${N_SUBJECTS} subjects:"
echo "    --jobs 4   (4 jobs × 24 threads = 96 threads, under 100 limit)"
echo "    --delay 300  (5 min delay to ease I/O load)"
echo ""
echo "  monitor progress:"
echo "    tail -f nordic_log.txt"
echo "    tail -f full_log.txt"
echo ""
echo "  feel like something's stuck?"
echo "    in your terminal type this: ps aux | grep subj-that-you-want-to-inspect"
echo "    if it shows you nothing or just one job, that means something's wrong."
echo "    go to the subject folder and see the processing log to troubleshoot."
echo ""
echo "***************************************************************"
