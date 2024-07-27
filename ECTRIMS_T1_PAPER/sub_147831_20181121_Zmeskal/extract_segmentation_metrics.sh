#!/bin/bash

# Paths to the input files
T1MAP_FILE="mp2rage_T1Map_r.nii.gz"
LESIONS_FILE="nasc_lesions.nii.gz"

# Define the output CSV file
OUTPUT_CSV="segmentation_results.csv"

# Initialize the output CSV with headers
echo "Label,Volume_mm3,Mean_T1" > "$OUTPUT_CSV"

# Define the labels to process
LABELS=(1 9)

# Loop through each label and calculate statistics
for LABEL in "${LABELS[@]}"; do
    # Threshold to isolate the current label, then calculate statistics
    VOLUME=$(c3d "$LESIONS_FILE" -thresh $LABEL $LABEL 1 0 -o - -dup "$T1MAP_FILE" -times -comp -label-statistics | grep "Volume" | awk '{print $3}')
    MEAN_T1=$(c3d "$LESIONS_FILE" -thresh $LABEL $LABEL 1 0 -o - -dup "$T1MAP_FILE" -times -comp -label-statistics | grep "Mean" | awk '{print $3}')
    
    # Append the results to the CSV
    echo "$LABEL,$VOLUME,$MEAN_T1" >> "$OUTPUT_CSV"
done