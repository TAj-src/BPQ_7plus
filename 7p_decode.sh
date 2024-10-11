#!/bin/bash
#########################################################
#
# Modified by G7TAJ for use with BPQMail 12/2018
#
# 7PLUS manager for LINUX F6FBB BBS - F6BVP - February 2015
# 7PLUS manager for LINUX Version 1.2 (10/99)
#
# F6BVP - http://f6bvp.org
#
# THESE 3 VARIABLES MUST BE INITIALIZED !
#
#
# Directory in which fbb software is installed
#
DESTDIR=/home/<usr>/linbpq
BASE_BPQ=$DESTDIR
#
# 7PLUS administrator for report mails
#
# Should be like (no space character !) :
#   SP_ADM=F5NUF@F6FBB.FMLR.FRA.EU
#   SP_ADM=F6FBB
#   SP_ADM="F5NUF@F6FBB.FMLR.FRA.EU F6FBB"
#
SP_ADM=YOUCALL@HOMEBBS
#
# Number of days to delete old 7plus parts
#
OLD_FILES=30
#
######################################################################
# Check carefully that the directories match your system
# Remember you will need a mail import for the mail.in file
# Check the files / dir's are the same as the export OR as find_7p.sh
#######################################################################
#
# MAIL.IN file
#
MAIL_IN=$BASE_BPQ/Mail/Import/mail.in
#
# Name (and path) of the 7plus program
#
SPLUS=$BASE_BPQ/7plus/7plus
#
# Name of the file created by mail Export
#
SP_LOG=$DESTDIR/Mail/Export/7plus/7plus.log
#
# Directory of the 7plus files (parts)
#
SP_DIR=$BASE_BPQ/7plus/extracted
#
# Directory for the decoded files
#
SP_RES=$SP_DIR/ok
#
########################################################
if [ ! -f $SP_LOG ]
then
        echo "No $SP_LOG file to process..."
exit 0
fi
if [ ! -d $SP_DIR ]
then
  echo "Creating $SP_DIR"
  mkdir $SP_DIR
  if [ $? != 0 ]
  then
    echo "Could not create $SP_DIR. Aborting..."
    exit 1
  fi
fi
if [ ! -d $SP_RES ]
then
  echo "Creating $SP_RES"
  mkdir $SP_RES
  if [ $? != 0 ]
  then
    echo "Could not create $SP_RES. Aborting..."
    exit 2
  fi
fi
# If a 7+ log file exists
# Move it into the 7P directory
#
if [ -f $SP_LOG ]
then
        mv $SP_LOG $SP_DIR/7pl_log
fi
#
# Go to the 7P directory
#
cd $SP_DIR
#
# Extract 7plus files from the log file and put them in the result directory
#
$SPLUS 7pl_log -y -x > /dev/null
#
# Go to the result directory to decode files
#
cd $SP_RES
for file in $SP_DIR/*.p01
do
  name=`basename $file .p01`
  echo -n "Trying to decode $SP_DIR/$name ... "
  $SPLUS $SP_DIR/$name > 7pbpq_tmp
  if [ $? = 0 ]
  then
    grep success 7pbpq_tmp >> 7pbpq_mail
    rm $SP_DIR/$name.p*
    echo "Ok"
  else
    echo "No"
  fi
  rm 7pbpq_tmp
done
# to stop errors if zero files exist
shopt -s nullglob
for file in $SP_DIR/*.7pl
do
  name=`basename $file .7pl`
  echo -n "Trying to decode $SP_DIR/$name for 7pl ... "
  $SPLUS $SP_DIR/$name > 7pbpq_tmp
  if [ $? = 0 ]
  then
echo -n "trying  $SP_DIR/$name.7pl"
    grep success 7pbpq_tmp >> 7pbpq_mail
    rm $SP_DIR/$name.7pl
    echo "Ok"
  else
    echo "No"
  fi
  rm 7pbpq_tmp
done
#
# Delete old parts only in the SP_DIR directory
#
find $SP_DIR -maxdepth 1 -daystart -atime +$OLD_FILES -name '*' -print -exec rm {} \; > 7pbpq_tmp
#
# Add the deleted files to the report file
#
if [ -s 7pbpq_tmp ]
then
  echo >> 7pbpq_mail
  echo "Deleting old 7plus parts:" >> 7pbpq_mail
  while read file
  do
    echo "   `basename $file`" >> 7pbpq_mail
  done < 7pbpq_tmp
fi
rm 7pbpq_tmp
#
# Create report message if needed
#
if [ -f 7pbpq_mail ]
then
  for ADM in $SP_ADM
  do
    (echo "SP $ADM" ; echo "7p Decode report" ; cat 7pbpq_mail ; echo "/EX" ) >> $MAIL_IN
  done
  rm 7pbpq_mail
fi
#
# All correct... Bye !
#
exit 0
