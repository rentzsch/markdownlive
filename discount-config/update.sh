#!/bin/sh

# Run the configure script
cd ../discount/
./configure.sh

# Copy important files
sed '1,/^ *\*\/ *$/ { d; }' <config.h >../discount-config/config.h
cp mkdio.h ../discount-config/mkdio.h

# Clean up unused files
git clean -f
