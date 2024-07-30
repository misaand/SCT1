#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_directory="Label_Segmentation_Results"
labels=(0 1 2 3 9 10)

# Check if the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Initialize the output files with headers
for label in "${labels[@]}"; do
    output_file="${output_directory}/label_${label}_results.csv"
    > "$output_file"  # Empty the file if it exists, or create it
done

# Process each CSV file
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract the subject label from the filename
        subject_label=$(basename "$csv_file" .csv)

        # Process each label separately
        for label in "${labels[@]}"; do
            output_file="${output_directory}/label_${label}_results.csv"

            # Add header if the file is empty (including "Subject" as the first column)
            if [ ! -s "$output_file" ]; then
                awk -v subject="$subject_label" -v label="$label" 'NR==1{print "Subject," $0; next} $2 == label {print subject "," $0}' "$csv_file" > "$output_file"
            else
                awk -v subject="$subject_label" -v label="$label" 'NR>1 && $2 == label {print subject "," $0}' "$csv_file" >> "$output_file"
            fi
        done
    fi
done

echo "Files have been successfully separated by label into the $output_directory directory."