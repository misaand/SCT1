#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_file="merged_segmentation_results.csv"

# Ensure output directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Initialize the output file and add the header from the first CSV file
first_file=true
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract subject name from filename
        subject=$(basename "$csv_file" .csv)
        
        if $first_file; then
            # Add the SubjectID to the header and write to the output file
            echo "SubjectID,$(head -n 1 "$csv_file")" > "$output_file"
            first_file=false
        fi
        
        # Process the file: Add SubjectID column, replace LabelID 10 with 8
        awk -F, -v subject="$subject" 'BEGIN {OFS=","} 
            NR > 1 {if ($1 == 10) $1 = 8; print subject, $0}' "$csv_file" >> "$output_file"
    fi
done

# Check if the output file was created and contains data
if [ -s "$output_file" ]; then
    echo "Files have been successfully merged into $output_file"
else
    echo "No data was merged. Check the input files and directory."
    exit 1
fi