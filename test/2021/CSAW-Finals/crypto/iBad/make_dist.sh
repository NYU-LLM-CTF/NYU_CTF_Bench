#!/usr/bin/env bash
rm -rf dist
mkdir dist
cp -r src dist
cp -r templates dist
cp -r static dist
rm dist/src/lib.rs
cp lib.public.rs dist/src/lib.rs
cp Cargo.toml dist
cp Dockerfile dist
zip dist.zip -r dist
