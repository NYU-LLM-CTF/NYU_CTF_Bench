
# First Bucket

## Solve

Player deduces that bucket is setup with `authenticated-read` as part of its ACL.

```
# ...authenticate as AWS user

# get link to access files
$ aws s3 ls s3://ad586b62e3b5921bd86fe2efa4919208/...

# ... find path to all necessary components

# get presigned link to relevant paths
$ aws s3 presign s3://ad586b62e3b5921bd86fe2efa4919208/...
```

## Setup

Create a new IAM user that has read access to objects and buckets in S3.

### First Bucket

We do this first in order to generate the info needed for retrieving the flag.

Create a bucket that does not have public-read priviledge. It should in the Ohio region (`us-east-2`).

Give access only to the IAM user with S3 read priviledge created earlier.

It is now configured only for access in an Ohio-based EC2 instance, with the proper credentials. Create a new presigned URL for distribution

```
$ aws s3 presign s3://super-top-secret-dont-look/.sorry/.for/.nothing/flag.txt --expires-in 604800
https://super-top-secret-dont-look.s3.us-east-2.amazonaws.com/.sorry/.for/.nothing/flag.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQHTF3NZUTQBCUQCK%2F20200909%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20200909T195323Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=3560cef4b02815e7c5f95f1351c1146c8eeeb7ae0aff0adc5c106f6488db5b6b
```

### Second Bucket

Create a bucket that has `authenticated-read` in the Northern California region (`us-west-1`). Bucket should first
be made public in order to set ACL:

```
$ aws put-bucket-acl --bucket <BUCKET> --acl authenticated-read
```

Run the following script to create layers of bogus directories and files. Credentials needed for next bucket are hidden
amongst them. All objects will also have `authenticated-read`:

```
$ python init_bucket.py
```

The information that is dispersed should be stored in `solve.txt`.

These objects contain necessary components for the next bucket: next bucket name, access key, path, signature. They figure out the date from the description.
