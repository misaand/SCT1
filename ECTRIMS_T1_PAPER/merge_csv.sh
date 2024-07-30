#!/bin/bash

# Directory containing the CSV files
input_directory="Segmentation_Results"
output_directory="Label_Segmentation_Results"

# Labels to filter by
labels=(0 1 2 3 9 10)

# Check if the input directory exists
if [ ! -d "$input_directory" ]; then
    echo "The directory $input_directory does not exist."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Initialize output files for each label
for label in "${labels[@]}"; do
    output_file="${output_directory}/label_${label}_results.csv"
    # Clear previous content or create the file with the header
    echo "Subject,Label,Volume,Mean_T1" > "$output_file"
done

# Process each CSV file
for csv_file in "$input_directory"/sub_*.csv; do
    if [ -f "$csv_file" ]; then
        # Extract the subject label from the filename
        subject_label=$(basename "$csv_file" .csv)
        
        # Process each label
        for label in "${labels[@]}"; do
            output_file="${output_directory}/label_${label}_results.csv"
            
            # Filter rows by label and add the subject column
            awk -F, -v subject="$subject_label" -v label="$label" 'NR>1 && $2 == label {print subject "," $0}' "$csv_file" >> "$output_file"
        done
    fi
done

echo "Files have been successfully split and saved in the $output_directory directory."