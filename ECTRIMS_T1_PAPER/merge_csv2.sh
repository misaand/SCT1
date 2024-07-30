#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"  # Replace with the path to your CSV files
output_directory="merged_results"    # Directory where merged files will be stored

# List of labels to segregate
labels=("0" "1" "2" "3" "9" "10")

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Initialize files with headers
for label in "${labels[@]}"; do
    echo "Subject,Label,OtherColumns..." > "$output_directory/merged_label_${label}.csv"
done

# Iterate over each CSV file in the input directory
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract the subject ID from the file name (excluding path and extension)
        subject_id=$(basename "$csv_file" .csv)
        
        # Read each line in the CSV file
        while IFS=, read -r label rest; do
            # Ignore header row or empty lines
            if [ "$label" != "Label" ] && [ -n "$label" ]; then
                # Find the appropriate file and append the data
                for l in "${labels[@]}"; do
                    if [ "$label" == "$l" ]; then
                        echo "$subject_id,$label,$rest" >> "$output_directory/merged_label_${label}.csv"
                    fi
                done
            fi
        done < "$csv_file"
    fi
done

echo "Merging completed. Check the directory '$output_directory' for results."