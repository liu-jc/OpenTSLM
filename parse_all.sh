#!/bin/bash
#
# This source file is part of the OpenTSLM open-source project
#
# SPDX-FileCopyrightText: 2025 Stanford University, ETH Zurich, and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

# Script to parse all predictions from different stages
# Usage: ./parse_all.sh <evaluation_results_directory>
#
# Example: ./parse_all.sh evaluation_results
#
# This script will parse predictions from:
#   - TSQA: <dir>/stage1_mcq/test_predictions.jsonl
#   - HAR-CoT: <dir>/stage3_cot/test_predictions.jsonl
#   - Sleep-CoT: <dir>/stage4_sleep_cot/test_predictions.jsonl
#   - ECG-QA-CoT: <dir>/stage5_ecg_cot/test_predictions.jsonl

set -e  # Exit on error

# Check if directory argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No directory provided"
    echo "Usage: $0 <evaluation_results_directory>"
    echo "Example: $0 evaluation_results"
    exit 1
fi

EVAL_DIR="$1"

# Get the script directory (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if evaluation directory exists
if [ ! -d "$EVAL_DIR" ]; then
    echo "Error: Directory '$EVAL_DIR' does not exist"
    exit 1
fi

echo "=========================================="
echo "Parsing all predictions from: $EVAL_DIR"
echo "=========================================="
echo ""

# Function to check if file exists before parsing
check_and_parse() {
    local file_path="$1"
    local parser_script="$2"
    local summary_file="$3"
    local stage_name="$4"
    
    if [ ! -f "$file_path" ]; then
        echo "Warning: File not found: $file_path"
        echo "Skipping $stage_name parsing..."
        echo ""
        return 1
    fi
    
    echo "Parsing $stage_name..."
    echo "  Input: $file_path"
    if [ -n "$summary_file" ]; then
        echo "  Summary: $summary_file"
        python "$parser_script" "$file_path" --summary_file "$summary_file"
    else
        python "$parser_script" "$file_path"
    fi
    echo ""
}

# Parse TSQA (stage1_mcq)
TSQA_FILE="$EVAL_DIR/stage1_mcq/results/test_predictions.jsonl"
TSQA_PARSER="$SCRIPT_DIR/evaluation/opentslm/tsqa/parse_predictions.py"
TSQA_SUMMARY="$EVAL_DIR/stage1_mcq/tsqa_predictions.summary.txt"
check_and_parse "$TSQA_FILE" "$TSQA_PARSER" "$TSQA_SUMMARY" "TSQA (Stage 1 MCQ)"

# Parse HAR-CoT (stage3_cot)
HAR_FILE="$EVAL_DIR/stage3_cot/results/test_predictions.jsonl"
HAR_PARSER="$SCRIPT_DIR/evaluation/opentslm/har_cot/parse_predictions.py"
HAR_SUMMARY="$EVAL_DIR/stage3_cot/har_cot_predictions.summary.txt"
check_and_parse "$HAR_FILE" "$HAR_PARSER" "$HAR_SUMMARY" "HAR-CoT (Stage 3)"

# Parse Sleep-CoT (stage4_sleep_cot)
SLEEP_FILE="$EVAL_DIR/stage4_sleep_cot/results/test_predictions.jsonl"
SLEEP_PARSER="$SCRIPT_DIR/evaluation/opentslm/sleep/parse_sleep_cot_data.py"
SLEEP_SUMMARY="$EVAL_DIR/stage4_sleep_cot/sleep_cot_predictions.summary.txt"
check_and_parse "$SLEEP_FILE" "$SLEEP_PARSER" "$SLEEP_SUMMARY" "Sleep-CoT (Stage 4)"

# Parse ECG-QA-CoT (stage5_ecg_cot)
ECG_FILE="$EVAL_DIR/stage5_ecg_cot/results/test_predictions.jsonl"
ECG_PARSER="$SCRIPT_DIR/evaluation/opentslm/ecg_qa_cot/parse_ecg_qa_cot_data.py"
ECG_SUMMARY="$EVAL_DIR/stage5_ecg_cot/ecg_qa_cot_predictions.summary.txt"
check_and_parse "$ECG_FILE" "$ECG_PARSER" "$ECG_SUMMARY" "ECG-QA-CoT (Stage 5)"

echo "=========================================="
echo "All parsing completed!"
echo "=========================================="


