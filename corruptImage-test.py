import os
from PIL import Image  # For image validation (optional)

def is_corrupt(filepath):
    """Attempts to open the image using Pillow. If it fails, considers the image corrupt.

    Args:
        filepath (str): Path to the image file.

    Returns:
        bool: True if the image cannot be opened, False otherwise.
    """

    try:
        Image.open(filepath).verify()  # Verify image integrity (optional)
        return False
    except (IOError, SyntaxError):
        return True

def list_and_remove_corrupt_images(folder_path, remove=False, confirmation=True):
    """Lists or removes corrupt image files within a folder and its subfolders.

    Args:
        folder_path (str): Path to the folder to scan.
        remove (bool, optional): If True, removes corrupt images (default: False).
        confirmation (bool, optional): If True, prompts for confirmation before removal (default: True).
    """

    for root, _, files in os.walk(folder_path):
        for filename in files:
            filepath = os.path.join(root, filename)
            if os.path.isfile(filepath) and is_corrupt(filepath):
                print(f"Found corrupt image: {filepath}")

                if remove:
                    if confirmation:
                        answer = input(f"Remove this image (y/n)? ").lower()
                        if answer == 'y':
                            os.remove(filepath)
                            print(f"Removed: {filepath}")
                    else:
                        os.remove(filepath)
                        print(f"Removed: {filepath}")

if __name__ == "__main__":
    folder_path = "/data/coco/22may/663e0eadb6cf949135e3d621/coco/train/crop"  # Replace with your actual folder path

    # Optional: Enable image verification (may increase processing time)
    # use_image_verification = True

    list_and_remove_corrupt_images(folder_path, remove=True, confirmation=False)
