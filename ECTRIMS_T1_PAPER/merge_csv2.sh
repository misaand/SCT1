#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"  # Directory containing the CSV files
output_file="merged_segmentation_results.csv"

# Check if the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Initialize the output file
first_file=true

# Process each CSV file in the directory
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract the subject label from the file name
        subject_label=$(basename "$csv_file" .csv)
        
        # Add subject label as a new column to each row
        if $first_file; then
            # For the first file, copy the header and add "Subject" to it
            # then add the data with the subject label
            awk -v label="$subject_label" 'NR==1{print $0",Subject"} NR>1{print $0","label}' "$csv_file" > "$output_file"
            first_file=false
        else
            # For subsequent files, skip the header and append data with subject label
            awk -v label="$subject_label" 'NR>1{print $0","label}' "$csv_file" >> "$output_file"
        fi
    fi
done

# Check if the output file was created
if [ -f "$output_file" ]; then
    echo "Files have been successfully merged into $output_file"
else
    echo "No CSV files were found in the directory $input_directory."
    exit 1
fi