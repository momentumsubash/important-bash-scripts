# Set the location to search (modify this)
search_dir="/home/dukkantek/Work/product_ml_train/product_recognition/datasets/train/Identv"

# File containing filenames to delete (modify this)
filelist="filelist1.txt"

# Check if search directory exists
if [ ! -d "$search_dir" ]; then
  echo "Error: Directory '$search_dir' does not exist."
  exit 1
fi

# Check if filelist exists
if [ ! -f "$filelist" ]; then
  echo "Error: File '$filelist' does not exist."
  exit 1
fi

# Loop through each filename in the filelist
while IFS= read -r filename; do
  # Find the file recursively and delete it with confirmation
  # if find "$search_dir" -name "$filename" -type d -exec rm -rvf {} \; ; then
  # if find "$search_dir" -name "$filename" -type d -print0 | sort -rz | xargs rm -rf; then
  dirfound=$(find "$search_dir" -name "$filename" -type d)
  if [ ! -z "$dirfound" ]; then
    echo "dir location: $dirfound"
   mkdir -p test-data/$filename
   cp -r $dirfound test-data/
  else
    echo "File not found: $filename"
    echo " $filename" >> missingdir
  fi
done < "$filelist"

echo "Finished processing file list."
