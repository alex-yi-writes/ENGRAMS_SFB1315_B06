#!/bin/bash

# =============================================================================
# Generate GNU Parallel commands for ENGRAMS DWI pipeline
#
# This script creates the command files needed to run the pipeline on
# multiple subjects using GNU parallel on the Superdome Flex cluster.
#
# Usage:
#   ./generate_parallel_commands.sh
#
# Output:
#   - nordic_commands.txt: Commands for NORDIC denoising step
#   - pipeline_commands.txt: Commands for post-NORDIC pipeline
#   - full_pipeline_commands.txt: Commands for complete pipeline (both steps)
#
# 20260127: alex
# =============================================================================

set -e

# =============================================================================
# Configuration - EDIT THESE
# =============================================================================

BASE_DIR="/mnt/work/yiy/ENGRAMS"
SCRIPTS_DIR="${BASE_DIR}/scripts"

# Path to compiled NORDIC (adjust after compilation)
# If using MATLAB directly instead of compiled version, set USE_COMPILED=0
USE_COMPILED=1
MCR_PATH="/share/apps/mcr/R2023b"
COMPILED_NORDIC="${SCRIPTS_DIR}/compiled_nordic/run_run_nordic.sh"

# Alternative: MATLAB batch mode path (if USE_COMPILED=0)
MATLAB_PATH="/share/apps/matlab/R2023b/bin/matlab"

# Subject list file (one subject ID per line)
SUBJECT_LIST="${SCRIPTS_DIR}/subjects.txt"

# Output command files
NORDIC_COMMANDS="${SCRIPTS_DIR}/nordic_commands.txt"
PIPELINE_COMMANDS="${SCRIPTS_DIR}/pipeline_commands.txt"
FULL_COMMANDS="${SCRIPTS_DIR}/full_pipeline_commands.txt"

# =============================================================================
# Check inputs
# =============================================================================

if [ ! -f "${SUBJECT_LIST}" ]; then
    echo "Subject list not found: ${SUBJECT_LIST}"
    echo ""
    echo "Create a file with one subject ID per line, e.g.:"
    echo "  sub-105v1s1"
    echo "  sub-207v1s1"
    echo "  sub-301v1s1"
    exit 1
fi

echo "======================================================================"
echo "Generating GNU Parallel commands"
echo "======================================================================"
echo ""
echo "Base directory: ${BASE_DIR}"
echo "Subject list: ${SUBJECT_LIST}"
echo "Number of subjects: $(wc -l < ${SUBJECT_LIST})"
echo ""

# =============================================================================
# Generate NORDIC commands
# =============================================================================

echo "Generating NORDIC commands..."
> "${NORDIC_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    # Skip empty lines and comments
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    if [ ${USE_COMPILED} -eq 1 ]; then
        # Compiled MATLAB version
        echo "${COMPILED_NORDIC} ${MCR_PATH} ${SUBJECT} ${BASE_DIR}" >> "${NORDIC_COMMANDS}"
    else
        # MATLAB batch mode
        echo "${MATLAB_PATH} -nodisplay -nosplash -nodesktop -r \"addpath('${SCRIPTS_DIR}'); try; ENGRAMS_denoise_NORDIC_compiled('${SUBJECT}', '${BASE_DIR}'); catch ME; disp(ME.message); exit(1); end; exit(0);\"" >> "${NORDIC_COMMANDS}"
    fi
    
done < "${SUBJECT_LIST}"

echo "  Written: ${NORDIC_COMMANDS}"
echo "  Commands: $(wc -l < ${NORDIC_COMMANDS})"

# =============================================================================
# Generate post-NORDIC pipeline commands
# =============================================================================

echo "Generating pipeline commands..."
> "${PIPELINE_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    echo "${SCRIPTS_DIR}/ENGRAMS_DWIpipeline_cluster.sh ${SUBJECT}" >> "${PIPELINE_COMMANDS}"
    
done < "${SUBJECT_LIST}"

echo "  Written: ${PIPELINE_COMMANDS}"
echo "  Commands: $(wc -l < ${PIPELINE_COMMANDS})"

# =============================================================================
# Generate full pipeline commands (wrapper that does both)
# =============================================================================

echo "Generating full pipeline commands..."
> "${FULL_COMMANDS}"

while IFS= read -r SUBJECT || [ -n "$SUBJECT" ]; do
    [[ -z "$SUBJECT" || "$SUBJECT" =~ ^# ]] && continue
    
    echo "${SCRIPTS_DIR}/ENGRAMS_full_pipeline_wrapper.sh ${SUBJECT}" >> "${FULL_COMMANDS}"
    
done < "${SUBJECT_LIST}"

echo "  Written: ${FULL_COMMANDS}"
echo "  Commands: $(wc -l < ${FULL_COMMANDS})"

# =============================================================================
# Print usage instructions
# =============================================================================

echo ""
echo "======================================================================"
echo "Usage Instructions"
echo "======================================================================"
echo ""
echo "OPTION 1: Run NORDIC and pipeline separately (recommended for debugging)"
echo ""
echo "  Step 1 - Run NORDIC on all subjects:"
echo "    parallel --jobs 4 --delay 300 --joblog nordic_log.txt < ${NORDIC_COMMANDS}"
echo ""
echo "  Step 2 - Run post-NORDIC pipeline on all subjects:"
echo "    parallel --jobs 8 --delay 60 --joblog pipeline_log.txt < ${PIPELINE_COMMANDS}"
echo ""
echo "OPTION 2: Run full pipeline in one go"
echo ""
echo "    parallel --jobs 4 --delay 300 --joblog full_log.txt < ${FULL_COMMANDS}"
echo ""
echo "----------------------------------------------------------------------"
echo "Notes on parallelisation:"
echo ""
echo "  - Superdome Flex has 224 threads"
echo "  - NORDIC is memory-intensive; use fewer jobs (4) with higher delay"
echo "  - Post-NORDIC steps can use more jobs (8)"
echo "  - Each job uses OMP_NUM_THREADS=${OMP_NUM_THREADS:-24} internally"
echo "  - Monitor with: tail -f nordic_log.txt"
echo ""
echo "  Recommended settings:"
echo "    NORDIC:    --jobs 4 --delay 300 (5 min delay, ~24 threads each)"
echo "    Pipeline:  --jobs 8 --delay 60  (1 min delay, ~24 threads each)"
echo ""
echo "======================================================================"
