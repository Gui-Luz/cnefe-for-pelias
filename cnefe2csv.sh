#!/bin/bash

### UNZIPPING
echo "Running cnefe unzip..."

output_dir="/app/output"
tmp_dir="/app/tmp"
data_dir="/app/data"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Create the temporary directory if it doesn't exist
mkdir -p "$tmp_dir"

# Find zip files recursively and store paths in an array
mapfile -d $'\0' zip_files < <(find "$data_dir" -name "*.zip" -type f -print0)

# Process zip files
for file in "${zip_files[@]}"; do
  echo "Processing $file"
  # Create a temporary directory for each zip file
  temp_dir=$(mktemp -d "$tmp_dir/zip.XXXXXXXXXX")

  # Extract zip file and process with gawk
  unzip -p "$file" | gawk -v FIELDWIDTHS='15 1 20 30 60 8 7 20 10 20 10 20 10 20 10 20 10 20 10 15 15 60 60 2 40 1 30 3 3 8' -v OFS=';' '{ $1=$1; print }' |
  awk -v upper_folder="$(basename "$(dirname "$file")")" -F ';' '$20 != "               " {
    fullAddress = $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $22 " " $30
    gsub(/  +/, " ", fullAddress)
    print upper_folder ";" $1 ";" $3 " " $4 " " $5 ";" $6 ";" $30 ";" $20 ";" $21 ";" fullAddress " " upper_folder
  }' |
  tr -s ' ' > "$temp_dir/$(basename "$file").csv"

  # Move the processed CSV file to the output directory
  mv "$temp_dir/$(basename "$file").csv" "$output_dir/"

done


# #!/bin/bash

# ### UNZIPPING
# echo "Running cnefe unzip..."

# output_dir="/app/output"
# tmp_dir="/app/tmp"
# data_dir="/app/data"

# # Create the output directory if it doesn't exist
# mkdir -p "$output_dir"

# # Create the temporary directory if it doesn't exist
# mkdir -p "$tmp_dir"

# # Find zip files recursively and store paths in an array
# mapfile -d $'\0' zip_files < <(find "$data_dir" -name "*.zip" -type f -print0)

# # Process zip files
# for file in "${zip_files[@]}"; do
#   echo "Processing $file"
#   # Create a temporary directory for each zip file
#   temp_dir=$(mktemp -d "$tmp_dir/zip.XXXXXXXXXX")

#   # Extract zip file and process with gawk
#   unzip -p "$file" | gawk -v FIELDWIDTHS='15 1 20 30 60 8 7 20 10 20 10 20 10 20 10 20 10 20 10 15 15 60 60 2 40 1 30 3 3 8' -v OFS=';' '{ $1=$1; print }' |
#   awk -v upper_folder="$(basename "$(dirname "$file")")" -F ';' '$20 != "               " {
#     fullAddress = $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $22 " " $30
#     gsub(/  +/, " ", fullAddress)
#     print upper_folder ";" $1 ";" $3 " " $4 " " $5 ";" $6 ";" $30 ";" $20 ";" $21 ";" fullAddress " " upper_folder
#   }' > "$temp_dir/$(basename "$file").csv"

#   # Move the processed CSV file to the output directory
#   mv "$temp_dir/$(basename "$file").csv" "$output_dir/"

# done
