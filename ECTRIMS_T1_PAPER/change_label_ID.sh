#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"

# Ensure the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Process each CSV file in the input directory
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Backup the original file (optional)
        cp "$csv_file" "${csv_file}.bak"

        # Modify LabelID 10 to 8 in the file and save the output
        awk -F, 'BEGIN {OFS=","} {if ($1 == 10) $1 = 8; print}' "$csv_file" > tmpfile && mv tmpfile "$csv_file"
        
        echo "Processed $csv_file"
    fi
done

echo "LabelID changes completed for all files in $input_directory."