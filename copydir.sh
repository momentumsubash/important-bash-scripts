#!/bin/bash

# Define source file and destination directory
source_file="filelist"
project_path="adnoc"
dest_dir="debugdata-$project_path"
mkdir -p $dest_dir

# Check if source file and destination directory are provided
if [ -z "$source_file" ] || [ -z "$dest_dir" ]; then
  echo "Error: Please provide source file and destination directory paths."
  exit 1
fi

# Check if source file exists
if [ ! -f "$source_file" ]; then
  echo "Error: Source file '$source_file' does not exist."
  exit 1
fi

# Loop through each directory in the file
while IFS= read -r directory; do
  # Skip empty lines or lines starting with # (comments)
  if [[ -z "$directory" ]] || [[ "$directory" =~ ^# ]]; then
    continue
  fi

  # Check if directory exists
  if [ ! -d "$project_path/$directory" ]; then
    echo "Warning: Directory '$directory' does not exist."
    echo "$directory" >> missingdir
    continue
  fi

  # Construct full source path (in case only directory name is in file)
  #source_path="$directory"
  #if [[ ! "$directory" =~ ^/ ]]; then
  #  source_path="$PWD/$directory"
  #fi

  ###### Copy the directory
  cp -r "$project_path/$directory" "$dest_dir"

  # Check the exit code of the copy command
  if [ $? -eq 0 ]; then
    echo "Directory '$project_path/$directory' copied successfully to '$dest_dir'."
  else
    echo "Error: Failed to copy directory '$project_path/$directory'."
  fi
done < "$source_file"

echo "Finished processing directories from '$source_file'."
