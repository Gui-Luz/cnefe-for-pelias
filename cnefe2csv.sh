#!/bin/bash

### UNZIPING
echo "Running cnefe unzip..."

output_file="/app/output/cnefe.csv"
tmp_dir="/app/tmp"
DATA_DIR="/app/data"

# Create temporary directory
mkdir -p "$tmp_dir"

# Find zip files recursively and store paths in an array
mapfile -d $'\0' zip_files < <(find "$DATA_DIR" -name "*.zip" -type f -print0)

# Process zip files
for file in "${zip_files[@]}"; do
  echo "Processing $file"
  # Extract zip file and process with gawk
  unzip -p "$file" | gawk -v FIELDWIDTHS='15 1 20 30 60 8 7 20 10 20 10 20 10 20 10 20 10 20 10 15 15 60 60 2 40 1 30 3 3 8' -v OFS=';' '{ $1=$1; print }' > "$tmp_dir/$(basename "$file").csv"
done

# Concatenate all CSV files and save as a single CSV
cat <(echo "sectorId;sectorSituation;addressType;addressTitle;addressName;addressNumber;addressModifier;element1;value1;element2;value2;element3;value3;element4;value4;element5;value5;element6;value7;lat;lon;locality;blank;specie;identification;indicator;collectiveIdentification;block;face;cep") "$tmp_dir"/*.csv > "$output_file"

### PROCESSING

echo "Running prepare-cnefe.sh..."

input_file="/app/output/cnefe.csv"
output_file="/app/output/cnefe_processed.csv"

# Count the number of lines in the input file
line_count=$(wc -l < "$input_file")
current_line=0

# Read CSV file and generate "fullAddress" column
awk -v line_count="$line_count" 'BEGIN{FS=OFS=";"} {
  fullAddress = $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $22
  gsub(/  +/, " ", fullAddress)
  print $0, "fullAddress"
  printf("Processed line: %d/%d\n", ++current_line, line_count) > "/dev/stderr"
}' "$input_file" > "$output_file"

echo "Processing completed. Output file: $output_file"



