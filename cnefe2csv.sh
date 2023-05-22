#!/bin/bash

### UNZIPPING
echo "Running cnefe processing..."

#Substituting , for ;
sed 's/,/;/g' municipios.csv > municipios2.csv

output_dir="/app/output"
tmp_dir="/app/tmp"
data_dir="/app/data"
municipios_csv="/app/municipios2.csv"  # Path to the municipios.csv file

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
  unzip -p "$file" | gawk -v FIELDWIDTHS='2 5 2 2 4 1 20 30 60 8 7 20 10 20 10 20 10 20 10 20 10 20 10 15 15 60 60 2 40 1 30 3 3 8' -v OFS=';' '{ $1=$1; print }' |
  awk -v upper_folder="$(basename "$(dirname "$file")")" -F ';' -v municipios_csv="$municipios_csv" '
    BEGIN {
      while ((getline < municipios_csv) > 0) {
        municipios[$1] = $4  # Store the city names in an array indexed by the ID
      }
      close(municipios_csv)
    }
    $24 != "               " {
      gsub(/ /, "", $2)  # Remove spaces in the ID column

      $2 = sprintf("%05d", $2)  # Append leading zeros to the ID column

      # Convert latitude from degrees minutes seconds to decimal coordinates
      lat_deg = int($24)
      lat_min = int(substr($24, 4, 2))
      lat_sec = substr($24, 7, 6)
      lat_dir = substr($24, 15, 1)
      latitude = lat_deg + lat_min/60 + lat_sec/3600
      if (index($24, "S") > 0) {
        latitude *= -1
      }

      # Convert longitude from degrees minutes seconds to decimal coordinates
      lon_deg = int($25)
      lon_min = int(substr($25, 4, 2))
      lon_sec = substr($25, 7, 6)
      lon_dir = substr($25, 15, 1)
      longitude = lon_deg + lon_min/60 + lon_sec/3600
      if (index($25, "O") > 0) {
        longitude *= -1
      }

      # Add the city name based on the ID
      city_id = $1$2
      city_name = municipios[city_id]
      if (city_name == "") {
        city_name = "Unknown"  # Set a default value if the city name is not found
      }

      fullAddress = $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $10 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $21 " " $22 " " $34 " " $23 " " city_name " " upper_folder
      gsub(/  +/, " ", fullAddress)

      print upper_folder ";" city_name ";" city_id ";" $7 " " $8 " " $9 ";" $10 ";" $34 ";" latitude ";" longitude ";" fullAddress ";"
    }' |

  tr -s ' ' > "$temp_dir/$(basename "$file").csv"

  # Move the processed CSV file to the output directory
  mv "$temp_dir/$(basename "$file").csv" "$output_dir/"

done
