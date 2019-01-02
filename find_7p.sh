#!/bin/bash
##################################################################
#
# File         : find_7p.sh
# Descriptipon : 7plus find script for LibBPQ
# Author       : G7TAJ@GB7BEX.#38.GBR.EU (Steve)
#
# This script trawls all new messages in BPQMail for any 7plus and 
# adds it to an output logfile
#
# Install in BASE_DIR
# Change variables to match your system
#
# add in CRONTAB before you call  7p_decode.sh (modified from F6FBB's script)
# e.g.
# #Find any new 7P messages in the .MES files
# 0 1 * * * /home/<usr>/linbpq/find_7p.sh > /dev/null 2>&1
#
# Replace /dev/null if you want to log the output (e.g. /tmp/find_7p.log)
#
# To decode the file to parts and whole files, see 7p_decode.sh
#
##################################################################

BASE_DIR="/home/<usr>/linbpq"
MAIL_DIR="$BASE_DIR/Mail"
OUT_DIR="$BASE_DIR/Mail/Export/7plus"
OUTPUT_FILE="$OUT_DIR/7plus.log"
LATEST_FILENAME="$BASE_DIR/latest_mailfile"

# Do not edit below this line
#############################################################################################
if [ -z "${PATH-}" ]; then export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin; fi

if [ ! -f $LATEST_FILENAME ]; then
 echo "No latest_mailfile exits creating last message scanned as 0 !"
 echo 0 > $BASE_DIR/latest_mailfile
fi

if [ ! -d "$OUT_DIR" ]; then
  echo "No output directory. Creating..."
  mkdir -p $OUT_DIR
fi

while read -r line; do
    LAST_FILE="$line"
    echo -n "Last Mesage Scanned was - $LAST_FILE"
done < "$LATEST_FILENAME"

NEW_LAST_FILE=$(ls -1 $MAIL_DIR/*.mes| sort -hr | head -n 1)
NEW_LAST_FILE=$(basename $NEW_LAST_FILE .mes)
NEW_LAST_FILE=${NEW_LAST_FILE##*m_}
NEW_LAST_FILE=$((10#$NEW_LAST_FILE))

echo "  ::  Latest Message- $NEW_LAST_FILE"

if [ "$LAST_FILE" -eq "$NEW_LAST_FILE" ];
then
 echo "No new messages...Quitting!"
 exit 1
fi

shopt -s nullglob

for  ((i=$LAST_FILE; i< $NEW_LAST_FILE; i++ ))
do
  mailfile=$(printf "m_%06d.mes" $i)
  if [ ! -f $MAIL_DIR/$mailfile ]; then
     echo "$i - File not found!"
  else
     echo -n "Looking inside $MAIL_DIR/$mailfile for 7pl ... "

     if `grep --quiet " go_7+." $MAIL_DIR/$mailfile` ;
     then
       echo " $i - contains 7p!"
       cat $MAIL_DIR/$mailfile >> $OUTPUT_FILE
     else
       echo
     fi
  fi
done

echo $NEW_LAST_FILE > $LATEST_FILENAME
echo "Finished"

