# BPQ_7plus
BPQ Mail 7plus find & decode Linux scripts

find_7p.sh   - finds 7plus in any new messages since it last ran

7p_decode.sh - decodes any parts in the log file created by find_7p.sh

Make cron entries for the above two, as often as you feel necessary (ever hour is probably ok, if overkill)

*** VER2
This script now puts the decoded files into the linbpq/HTML/7plus folder (needs creating).
It creates a `list.csv` file with the files in this directory which the index.html file reads to display
when you visit the webUI , e.g. http://127.0.0.1:8080/7plus/index.html


The file 'latest_mailfile' ( created automatically if not present with a value of 0 ) holds the last message it has processed.
If, on first run, you don't want it to do all your messages, create this file with a starting message number inside ( format: 3187 ) 

Run find_7p before 7p_decode

To get the mail imported, make sure your script matches the BPQMail forward import file definition

You will need the 7plus executable for your distro. I used https://sourceforge.net/projects/linfbb/files/7plus/7plus.tar.bz2
You will need to build the source (I have uploaded a version made on a RaspPi here - rename it to 7plus for the script to work)
