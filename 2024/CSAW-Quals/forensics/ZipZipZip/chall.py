import zipfile
import os

def split_string_into_chunks(s, chunk_size=5):
    return [s[i:i + chunk_size] for i in range(0, len(s), chunk_size)]

def create_nested_zip(chunks, base_name="chunk"):
    previous_zip_filename = None

    # Iterate over chunks backwards, creating zips from the last to the first
    for index in reversed(range(len(chunks))):
        zip_filename = f"{base_name}_{index}.zip"
        with zipfile.ZipFile(zip_filename, 'w') as zipf:
            zipf.writestr(f"{base_name}_{index}.txt", chunks[index])
            if previous_zip_filename:
                zipf.write(previous_zip_filename, os.path.basename(previous_zip_filename))
                os.remove(previous_zip_filename)
        previous_zip_filename = zip_filename

# Example usage
import base64

# Load your file here; for example, a 'flag.jpg'
with open("csaw_flag.png", "rb") as image_file:
    input_string = base64.b64encode(image_file.read()).decode('utf-8')

# Split the base64 string into manageable chunks
chunks = split_string_into_chunks(input_string)

# Create a nested zip structure
create_nested_zip(chunks)
