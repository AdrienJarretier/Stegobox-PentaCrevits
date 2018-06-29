#!/bin/bash

echo 'Content-type: application/json'
echo ''

echo '['

images=""

for image in ../imgs/*
do

  images=$images'"imgs/'$(basename $image)'"'

done

images=$(echo $images | sed 's/""/","/g')

echo $images

echo ']'

exit 0
