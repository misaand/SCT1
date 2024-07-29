#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_file="merged_segmentation_results.csv"

# Check if the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Check for files beginning with 'sub_'
csv_files=("$input_directory"/sub_*.csv)
if [ ! -f "${csv_files[0]}" ]; then
    echo "No files starting with 'sub_' found in $input_directory."
    exit 1
fi

# Initialize the output file and add the header from the first CSV file
first_file=true
for csv_file in "${csv_files[@]}"; do
    if [ "$first_file" = true ]; then
        # Copy the header and content from the first file
        cat "$csv_file" > "$output_file"
        first_file=false
    else
        # Skip the header and append the rest of the content
        tail -n +2 "$csv_file" >> "$output_file"
    fi
done

echo "Files have been successfully merged into $output_file"