Extract the `~/ctf_files/files.zip` to the current directory and run the following python script:

```
import os

# Known plaintext-ciphertext pairs
known_pairs = []
with open("files/a25981adfb782d04cccfb2ad66ae8e63ead31f62fb898913f1ec99359f2e1c4b.pdf.cryptastic", "rb") as ef, \
        open("files/us-aers-ransomware.pdf.backup", "rb") as pf:
    known_pairs.append((ef.read(), pf.read()))

# Function to perform XOR operation
def xor_bytes(a, b):
    return bytes(x ^ y for x, y in zip(a, b))

# Iterate over known plaintext-ciphertext pairs
for plaintext, ciphertext in known_pairs:
    # Calculate keystream by XORing plaintext with corresponding ciphertext
    keystream = xor_bytes(plaintext, ciphertext)

    # Decrypt all encrypted files using the calculated keystream
    for filename in os.listdir("files"):
        if filename.endswith("cryptastic"):
            with open(os.path.join("files", filename), "rb") as file:
                encrypted_data = file.read()

            # Decrypt the file by XORing with the keystream
            decrypted_data = xor_bytes(encrypted_data, keystream)

            # Save the decrypted data to a new file
            with open(os.path.join("files", filename+".dec"), "wb") as file:
                file.write(decrypted_data)
```

After decrypting the files, install `poppler-utils` and read the pdf text with `pdftotext` to get the flag:

```
sudo apt install poppler-utils
pdftotext files/ea6b505ffded681a256232ed214d4c3b410c8b4f052775eb7e67dcbd5af64e63.pdf.cryptastic.dec -
```
