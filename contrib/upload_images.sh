#!/bin/bash

s3cmd sync --delete-removed ./images/ s3://frobots-assets/images/
s3cmd sync --delete-removed ./images/ s3://frobots-prod/images/
s3cmd sync --delete-removed ./images/ s3://frobots-staging/images/