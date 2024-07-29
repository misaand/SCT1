#!/bin/bash

# Directory containing the CSV files
input_directory="path_to_csv_files"  # Replace with the actual path
output_file="merged_segmentation_results.csv"

# Remove output file if it exists
rm -f "$output_file"

# Get the header from the first CSV file
first_file=$(ls "$input_directory"/*.csv | head -n 1)
if [[ -z "$first_file" ]]; then
  echo "No CSV files found in the directory."
  exit 1
fi

# Add the header to the output file
head -n 1 "$first_file" > "$output_file"
echo ",Subject" >> "$output_file"  # Adding Subject column header

# Process each CSV file
for csv_file in "$input_directory"/*.csv; do
  # Get the filename without the path and extension
  filename=$(basename "$csv_file" .csv)
  
  # Skip the header and append the rest to the output file
  # Add the filename as the 'Subject' column
  tail -n +2 "$csv_file" | awk -v subject="$filename" 'BEGIN { FS=OFS="," } { print $0, subject }' >> "$output_file"
done

echo "Data successfully merged into $output_file"