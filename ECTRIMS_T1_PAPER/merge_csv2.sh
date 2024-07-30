#!/bin/bash

# Input file and output directory
input_file="merged_segmentation_results.csv"
output_directory="Label_Segmentation_Results"

# Labels to filter by
labels=(0 1 2 3 9 10)

# Ensure output directory exists
mkdir -p "$output_directory"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file $input_file not found!"
    exit 1
fi

# Extract the header
header=$(head -n 1 "$input_file")

# Process each label separately
for label in "${labels[@]}"; do
    output_file="${output_directory}/label_${label}_results.csv"
    # Write header to output file
    echo "$header" > "$output_file"
    # Append filtered rows for the current label
    awk -F, -v label="$label" '$1 == label {print $0}' "$input_file" >> "$output_file"
done

echo "Data successfully split into separate files by label in $output_directory."