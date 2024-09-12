import zipfile
import os
import base64

def extract_nested_zip(zip_filename, base_name="chunk"):
    text_accumulator = []
    
    # Start with the outermost zip file
    current_zip = zip_filename
    
    while True:
        # Open the current zip file
        with zipfile.ZipFile(current_zip, 'r') as zipf:
            # Extract the text file name based on the pattern we know
            text_filename = current_zip.replace('.zip', '.txt')
            with zipf.open(text_filename) as file:
                # Accumulate base64 string from each text file
                text_accumulator.append(file.read().decode('utf-8'))
            
            # Get the list of files in the zip file
            files_in_zip = zipf.namelist()
            # Find the next zip file to process
            next_zip = [f for f in files_in_zip if f.endswith('.zip')]
            
            if not next_zip:
                break  # Exit loop if there are no more zip files
            
            current_zip = next_zip[0]  # There should be only one zip file nested inside
            
            # Optionally extract the zip file to the current directory
            zipf.extract(current_zip)

    # Join all base64 strings and decode them
    base64_string = ''.join(text_accumulator)
    image_data = base64.b64decode(base64_string)
    
    # Write the decoded data to an image file
    with open('output_image.jpg', 'wb') as image_file:
        image_file.write(image_data)
    
    # Clean up extracted zip files if you wish
    for filename in os.listdir():
        if filename.endswith('.zip'):
            os.remove(filename)

# Provide the name of the outermost zip file
extract_nested_zip('chunk_0.zip')
