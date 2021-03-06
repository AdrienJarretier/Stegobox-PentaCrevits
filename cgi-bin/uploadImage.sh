#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
  TMPOUT=tmp/tmpImgUpload
  cat >$TMPOUT

  # Get the line count
  LINES=$(wc -l $TMPOUT | cut -d ' ' -f 1)

  filename=$(head -2 $TMPOUT | tail -1 | sed 's/.*filename="\(.*\)".*/\1/g')

  # Remove the first four lines
  tail -$((LINES - 4)) $TMPOUT >$TMPOUT.1

  # Remove the last line
  head -$((LINES - 5)) $TMPOUT.1 >$TMPOUT

  # Copy everything but the new last line to a temporary file
  head -$((LINES - 6)) $TMPOUT > ../imgs/$filename

  # Copy the new last line but remove trailing \r\n
  tail -1 $TMPOUT | perl -p -i -e 's/\r\n$//' >> ../imgs/$filename

  echo 'Content-type: application/json'
  echo ''

  echo "{\"filePath\" : \"imgs/$filename\"}"

fi

exit 0
