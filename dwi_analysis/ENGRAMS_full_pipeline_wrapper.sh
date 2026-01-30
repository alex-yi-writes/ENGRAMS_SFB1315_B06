#!/bin/bash

# ##############################################################
# full DWI pipeline wrapper for ENGRAMS
#
# this script runs both NORDIC denoising and the post-NORDIC pipeline
# for a single subject. use this for SDFlex parallel computing
#
# usage:
#   ./ENGRAMS_full_pipeline_wrapper.sh <subject_id> [temporal_phase_value]
#
# example:
#   ./ENGRAMS_full_pipeline_wrapper.sh sub-207v1s1        # uses default temporal_phase=3
#   ./ENGRAMS_full_pipeline_wrapper.sh sub-207v1s1 1      # uses temporal_phase=1
#   ./ENGRAMS_full_pipeline_wrapper.sh sub-207v1s1 3      # uses temporal_phase=3
#
# 20260127: alex: first wrote the wrapper (clunky)
# 20260129: alex: added temporal_phase_value parameter for experimentation
# ##############################################################

set -e
set -u

# ##############################################################
# config
# ##############################################################

BASE_DIR="/mnt/work/yiy/ENGRAMS"
SCRIPTS_DIR="${BASE_DIR}/scripts"

# NORDIC config
USE_COMPILED=1
MCR_PATH="/mnt/work/schuetzeh/images/mcr/R2023a" # have to change this!!
COMPILED_NORDIC="${SCRIPTS_DIR}/compiled_nordic/run_run_nordic.sh"
MATLAB_PATH="/share/apps/matlab/R2023a/bin/matlab" # for hydra, not SDFlex

# NORDIC parameters (i'm experimenting for now)
# temporal_phase: 1=minimal, 2=intermediate, 3=aggressive phase correction
# for 7T UHF multi-shell dMRI, 3 is recommended (see the source code)
DEFAULT_TEMPORAL_PHASE=3

# thread configuration
export OMP_NUM_THREADS=24

# ##############################################################
# parse args
# ##############################################################

if [ $# -lt 1 ]; then
    echo "Usage: $0 <subject_id> [temporal_phase_value]"
    echo ""
    echo "Arguments:"
    echo "  subject_id           Subject identifier (e.g., sub-207v1s1)"
    echo "  temporal_phase_value Optional: 1, 2, or 3 (default: ${DEFAULT_TEMPORAL_PHASE})"
    exit 1
fi

SUBJECT="$1"
TEMPORAL_PHASE="${2:-${DEFAULT_TEMPORAL_PHASE}}"

#validate temporal_phase_value
if [[ ! "${TEMPORAL_PHASE}" =~ ^[123]$ ]]; then
    echo "error: temporal_phase_value must be 1, 2, or 3 (got: ${TEMPORAL_PHASE})"
    exit 1
fi

# ##############################################################
# don't skip on logging!
# ##############################################################

LOG_DIR="${BASE_DIR}/analyses/${SUBJECT}/dwi"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/${SUBJECT}_full_pipeline.log"

exec > >(tee -a "${LOG_FILE}") 2>&1

echo "##############################################################"
echo "full DWI Pipeline for ${SUBJECT}"
echo "started: $(date)"
echo "host: $(hostname)"
echo "temporal phase value: ${TEMPORAL_PHASE}"
echo "##############################################################"

# ##############################################################
# check if already completed (should be R2023a)
# ##############################################################

NORDIC_DIR="${BASE_DIR}/analyses/${SUBJECT}/dwi/nordic"
NORDIC_COMPLETE="${NORDIC_DIR}/${SUBJECT}_nordic_complete.txt"
PIPELINE_COMPLETE="${LOG_DIR}/${SUBJECT}_pipeline_complete.txt"

if [ -f "${PIPELINE_COMPLETE}" ]; then
    echo ""
    echo "pipeline already completed for ${SUBJECT}"
    echo "remove ${PIPELINE_COMPLETE} to re-run"
    echo ""
    exit 0
fi

# ##############################################################
# STEP 1: NORDIC denoising
# ##############################################################

echo ""
echo "##############################################################"
echo "STEP 1: NORDIC denoising"
echo "##############################################################"

if [ -f "${NORDIC_COMPLETE}" ]; then
    echo "NORDIC already completed, skipping..."
else
    echo "running NORDIC with temporal_phase=${TEMPORAL_PHASE}..."
    
    if [ ${USE_COMPILED} -eq 1 ]; then
        # Compiled version
        if [ ! -x "${COMPILED_NORDIC}" ]; then
            echo "error: Compiled NORDIC not found: ${COMPILED_NORDIC}"
            exit 1
        fi
        ${COMPILED_NORDIC} ${MCR_PATH} ${SUBJECT} ${BASE_DIR} ${TEMPORAL_PHASE}
    else
        # MATLAB batch mode
        ${MATLAB_PATH} -nodisplay -nosplash -nodesktop -r \
            "addpath('${SCRIPTS_DIR}'); \
             try; \
                 ENGRAMS_denoise_NORDIC_compiled('${SUBJECT}', '${BASE_DIR}', ${TEMPORAL_PHASE}); \
             catch ME; \
                 disp(ME.message); \
                 exit(1); \
             end; \
             exit(0);"
    fi
    
    # is NORDIC really done? check
    if [ ! -f "${NORDIC_COMPLETE}" ]; then
        echo "error: NORDIC did not complete successfully"
        exit 1
    fi
fi

# ##############################################################
# STEP 2: post-NORDIC pipeline (includes dtifit)
# ##############################################################

echo ""
echo "##############################################################"
echo "STEP 2: post-NORDIC pipeline"
echo "##############################################################"

${SCRIPTS_DIR}/ENGRAMS_DWIpipeline_postNORDIC_SDflex.sh ${SUBJECT}

# ##############################################################
# Completion
# ##############################################################

echo ""
echo "##############################################################"
echo "full pipeline complete for ${SUBJECT}"
echo "finished: $(date)"
echo "##############################################################"
