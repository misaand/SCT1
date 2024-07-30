#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_directory="Merged_Results"

# Labels to filter by
labels=(0 1 2 3 9 10)

# Ensure output directory exists
mkdir -p "$output_directory"

# Initialize output files with headers
for label in "${labels[@]}"; do
    output_file="${output_directory}/label_${label}_results.csv"
    echo "Subject,Label,Volume,Mean_T1" > "$output_file"
done

# Iterate over all CSV files in the input directory
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract subject name from filename
        subject=$(basename "$csv_file" .csv)
        
        # Process each label separately
        for label in "${labels[@]}"; do
            output_file="${output_directory}/label_${label}_results.csv"
            
            # Extract rows matching the label and add the subject column
            awk -v subject="$subject" -F, '$1 == "'$label'" {print subject "," $0}' "$csv_file" >> "$output_file"
        done
    fi
done

echo "Segmentation results have been successfully merged into separate files for each label."