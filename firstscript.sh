#!/bin/bash

# Set the main directory and output directory
main_dir="ECTRIMS_T1_PAPER"
output_dir="${main_dir}/Segmentation_Results"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over each subject folder starting with "sub_"
for subdir in "$main_dir"/sub_*; do
    if [ -d "$subdir" ]; then
        subject_name=$(basename "$subdir")
        
        # Define file paths
        mp2rage_location_file="${subdir}/mp2rage_location_r.nii.gz"
        mp2rage_lesion_file="${subdir}/mp2rage_fujimoto_r_lesion.nii.gz"
        t1map_file="${subdir}/mp2rage_T1Map_r.nii.gz"
        
        cc_to_c3_output="${subdir}/CCtoC3.nii.gz"
        lesions_output="${subdir}/lesions.nii.gz"
        nasc_lesions_output="${subdir}/nasc_lesions.nii.gz"
        segmentation_results_csv="${output_dir}/${subject_name}_segmentation_results_comma.csv"

        # Check if the required input files exist
        if [ -f "$mp2rage_location_file" ] && [ -f "$mp2rage_lesion_file" ] && [ -f "$t1map_file" ]; then
            # Step 1: Process mp2rage_location_r.nii.gz
            c3d "$mp2rage_location_file" -replace 2 1 3 1 4 1 5 0 6 0 7 0 8 0 -o "$cc_to_c3_output"
            
            # Step 2: Process mp2rage_fujimoto_r_lesion.nii.gz
            c3d "$mp2rage_lesion_file" -replace 1 9 -o "$lesions_output"
            
            # Step 3: Combine the results to create nasc_lesions.nii.gz
            c3d "$cc_to_c3_output" "$lesions_output" -add -o "$nasc_lesions_output"
            
            # Step 4: Generate statistics and format with commas for decimal points
            c3d "$t1map_file" "$nasc_lesions_output" -lstat | sed 's/\./,/g' > "$segmentation_results_csv"
            
            # Add the results to the Git repository and commit
            git add "$segmentation_results_csv"
            git commit -m "Add segmentation results for ${subject_name}"
        else
            echo "Missing required files for ${subject_name}. Skipping."
        fi
    fi
done