# BPQ_7plus
BPQ Mail 7plus find & decode Linux scripts

find_7p.sh   - finds 7plus in any new messages since it last ran

7p_decode.sh - decodes any parts in the log file created by find_7p.sh

The file 'latest_mailfile' ( created automatically if not present with a value of 0 ) holds the last message it has processed.
If, on first run, you dont want it to do all your messages, create this file with a starting message number inside ( format: 3187 ) 

Run find_7p before 7p_decode

To get the mail imported, make sure your script matches the BPQMail forward import file definition

You will need the 7plus executable for your distro. I used https://sourceforge.net/projects/linfbb/files/7plus/7plus.tar.bz2
You will need to build the source (I have uploaded a version make on a RaspPi here - rename it tp 7plus for the script to work)
