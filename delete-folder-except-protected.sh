#!/bin/bash

# Check if required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory_path> <protected_folders_file>"
    echo "Example: $0 /path/to/directory protected.txt"
    exit 1
fi

# Get directory path and protected folders file
DIR_PATH="$1"
PROTECTED_FILE="$2"

# Check if directory exists
if [ ! -d "$DIR_PATH" ]; then
    echo "Error: Directory does not exist: $DIR_PATH"
    exit 1
fi

# Check if protected file exists
if [ ! -f "$PROTECTED_FILE" ]; then
    echo "Error: Protected folders file does not exist: $PROTECTED_FILE"
    exit 1
fi

# Create log file
LOG_FILE="deletion_log_$(date +%Y%m%d_%H%M%S).txt"
echo "Folder Deletion Log - $(date)" > "$LOG_FILE"
echo "================================" >> "$LOG_FILE"

# Initialize counters
total_checked=0
total_protected=0
total_deleted=0
total_errors=0

# Function to check if a folder is protected
is_protected() {
    local folder_name="$1"
    if grep -Fxq "$folder_name" "$PROTECTED_FILE"; then
        return 0  # Protected
    else
        return 1  # Not protected
    fi
}

# Process folders
process_folders() {
    local current_dir="$1"
    local indent="$2"
    
    # Loop through all items in the directory
    for item in "$current_dir"/*; do
        if [ -d "$item" ]; then
            ((total_checked++))
            folder_name=$(basename "$item")
            
            if is_protected "$folder_name"; then
                ((total_protected++))
                echo "${indent}Protecting: $folder_name"
                echo "Protected: $item" >> "$LOG_FILE"
            else
                echo "${indent}Deleting: $folder_name"
                echo "Deleting: $item" >> "$LOG_FILE"
                if rm -rf "$item"; then
                    ((total_deleted++))
                    echo "Successfully deleted: $item" >> "$LOG_FILE"
                else
                    ((total_errors++))
                    echo "Error deleting: $item" >> "$LOG_FILE"
                fi
            fi
        fi
    done
}

# Display protected folders
echo "Protected folders from $PROTECTED_FILE:"
cat "$PROTECTED_FILE"
echo -e "\nWorking directory: $DIR_PATH"

# Confirm before proceeding
echo -e "\nThis will:"
echo "1. Keep folders listed in $PROTECTED_FILE"
echo "2. Delete all other folders in $DIR_PATH"
echo -n "Do you want to continue? (y/n): "
read -r response

if [ "$response" != "y" ]; then
    echo "Operation cancelled"
    exit 0
fi

# Start processing
echo -e "\nStarting folder processing..."
process_folders "$DIR_PATH" ""

# Print summary
echo -e "\nProcessing Summary:"
echo "==================="
echo "Total folders checked: $total_checked"
echo "Protected folders: $total_protected"
echo "Deleted folders: $total_deleted"
echo "Errors encountered: $total_errors"
echo -e "\nDetailed log saved to: $LOG_FILE"

# Add summary to log file
{
    echo -e "\nFinal Summary"
    echo "=============="
    echo "Total folders checked: $total_checked"
    echo "Protected folders: $total_protected"
    echo "Deleted folders: $total_deleted"
    echo "Errors encountered: $total_errors"
    echo "Process completed at: $(date)"
} >> "$LOG_FILE"

echo -e "\nProcess completed!"
