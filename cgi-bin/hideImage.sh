#!/bin/bash

decodeURL() { printf "%b\n" "$(sed 's/+/ /g; s/%\([1-9a-f][0-9a-f]\)/\\x\1/gi;')"; }

if [ "$REQUEST_METHOD" = "POST" ]; then

  TMPOUT=tmp/tmpHideImage
  OUPUT_FILE=$(mktemp -up messagesCaches XXXXXXXXXX)

  cat >$TMPOUT
  echo '' >> $TMPOUT

  text=$(decodeURL <<< $(sed 's/.*text=\([^&]*\).*/\1/g' $TMPOUT))
  image=$(decodeURL <<< $(sed 's/.*image=\([^&]*\).*/\1/g' $TMPOUT))

  OUPUT_FILE=$OUPUT_FILE.$(echo $image | sed 's/.*\.\(.*\)/\1/')

  # echo 'image  : '$image > $TMPOUT.test

  echo $text | sed 's/%0A/\n/g' > $TMPOUT.text

  steghide embed -ef $TMPOUT.text -cf ../$image -sf ../$OUPUT_FILE -p 'password' -f -q

  # # Get the line count
  # LINES=$(wc -l $TMPOUT | cut -d ' ' -f 1)

  # # filename=$(head -2 $TMPOUT | tail -1 | sed 's/.*filename="\(.*\)".*/\1/g')

  # # Remove the first four lines
  # tail -$((LINES - 4)) $TMPOUT >$TMPOUT.1

  # # Remove the last line
  # head -$((LINES - 5)) $TMPOUT.1 >$TMPOUT

  # # Copy everything but the new last line to a temporary file
  # head -$((LINES - 6)) $TMPOUT > $TMPOUT.1

  # # Copy the new last line but remove trailing \r\n
  # tail -1 $TMPOUT | perl -p -i -e 's/\r\n$//' >> $TMPOUT.1

  if (( $? == 1 ))
  then

    echo 'status: 500'
    echo ''

  else

    echo 'Content-type: application/json'
    echo ''

    echo "{\"filePath\" : \"$OUPUT_FILE\"}"

  fi

fi




exit $?
