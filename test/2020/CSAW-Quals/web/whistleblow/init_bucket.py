#!/usr/bin/env python3
"""
init_bucket.py

    Instantiates an empty AWS S3 bucket with bogus objects for the user to
    investigate. Credentials for another bucket are to be dispersed, which the user will then use
    to attempt to connect to another bucket in another region.
"""

import uuid
import boto3
import random
import string

# name of the first bucket
BUCKET_NAME = "ad586b62e3b5921bd86fe2efa4919208"

# information we want to hide and disperse in the first bucket
# if you are seeing this source code publicly, they probably don't work anymore :p
TARGET_BUCKET = "s3://super-top-secret-dont-look"
TARGET_PATH = ".sorry/.for/.nothing/"
TARGET_ACCESS_KEY = "AKIAQHTF3NZUTQBCUQCK"
TARGET_SIGNATURE = "3560cef4b02815e7c5f95f1351c1146c8eeeb7ae0aff0adc5c106f6488db5b6b"


def get_random_string(length):
    """ Generate bogus data for each text file we create """
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(length))


def main():
    client = boto3.client("s3")

    # first, create 20 pseudorandom uuid folders
    parent_dirs = [ str(uuid.uuid4()) for _ in range(20) ]

    # for each pseudorandom parent, create 5 more children for each
    child_dirs = [ path + "/" + str(uuid.uuid4()) for path in parent_dirs for _ in range(5) ]

    # now in each directory, instantiate a two empty bogus text files
    files = [ path + "/" + str(uuid.uuid4()) + ".txt" for path in child_dirs for _ in range(2) ]

    # convert files to dict, with filename as key and bogus content as value
    files = {
        path: get_random_string(30)
        for path in files
    }

    # plant our metadata randomly throughout the first bucket
    randkeys = [ random.choice(list(files.items()))[0] for _ in range(4) ]
    files[randkeys[0]] = TARGET_BUCKET
    files[randkeys[1]] = TARGET_PATH
    files[randkeys[2]] = TARGET_ACCESS_KEY
    files[randkeys[3]] = TARGET_SIGNATURE

    # now upload everything! only readers that are authenticated can access these files
    print("Creating challenge bucket in S3")
    for key, body in files.items():
        print("Creating object `{}`".format(key))
        client.put_object(
            ACL="authenticated-read",
            Bucket=BUCKET_NAME, Body=body, Key=key
        )

    # write the location of the files with the information we hidden
    with open("solve.txt", "w") as fd:
        fd.write("Bucket Name: `{}`\n".format(randkeys[0]))
        fd.write("Path: `{}`\n".format(randkeys[1]))
        fd.write("Access Key: `{}`\n".format(randkeys[2]))
        fd.write("Signature: `{}`\n".format(randkeys[3]))

    print("Done!")

if __name__ == "__main__":
    exit(main())
