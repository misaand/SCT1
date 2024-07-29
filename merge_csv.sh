#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_file="merged_segmentation_results.csv"

# Check if the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Initialize the output file
> "$output_file"

# Process each CSV file
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract the subject label from the filename
        subject_label=$(basename "$csv_file" .csv)
        
        # Read the CSV file
        # For the first file, include the header with the added "Subject" column
        # For subsequent files, skip the header
        if [ ! -s "$output_file" ]; then
            # Add header with a new column "Subject"
            awk -v subject="$subject_label" 'NR==1{print "Subject," $0; next} {print subject "," $0}' "$csv_file" > "$output_file"
        else
            # Append data without header
            awk -v subject="$subject_label" 'NR>1 {print subject "," $0}' "$csv_file" >> "$output_file"
        fi
    fi
done

# Check if the output file was created and has content
if [ -s "$output_file" ]; then
    echo "Files have been successfully merged into $output_file"
else
    echo "No CSV files were processed or the output file is empty."
    exit 1
fi