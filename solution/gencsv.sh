#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_index> <end_index>"
    exit 1
fi

# Read the start and end index from arguments
start_index=$1
end_index=$2

# Check if start_index is less than or equal to end_index
if [ $start_index -gt $end_index ]; then
    echo "Error: start_index must be less than or equal to end_index."
    exit 1
fi

# Generate the file inputFile
output_file="inputFile"

# Remove the file if it already exists
rm -f "$output_file"

# Loop from start_index to end_index and write to the output file
for i in `seq $start_index $end_index`; 
do
    # Generate a random number between 1 and 100
    random_number=$(( RANDOM % 1000 + 1 ))
    # Write the index and the random number to the file
    echo "$i, $random_number" >> "$output_file"
done


