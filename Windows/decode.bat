@echo off
setlocal enabledelayedexpansion


REM **** 7plus extractor from BPQ message files by G7TAJ@GB7BEX.#38.GBR.EU
REM **** put this and 7plus.exe in a directory. 
REM **** edit the mail path to the correct location of your BPQ\Mail directory
REM **** 
REM 7plus download - http://ring.u-toyama.ac.jp/archives/misc/ham/funet/packet/misc/7pl221en.zip


REM *** edit this line for where your BPQ mail directory is ***
set mail_path="c:\bpq\mail\"

set output_path=%cd%
if not exist "%output_path%\decoded" mkdir "%output_path%\decoded" 

echo BPQ Mail DIR : %mail_path%
cd %mail_path%

if not exist lastmsg.txt (
 echo it doesnt exist
 rem echo 0 > lastmsg.txt
)

for /f "delims=" %%g in (%output_path%\lastmsg.txt) do (
 set lastmsg=%%g
)


Echo Last message checked was %lastmsg% 
echo.
set newlastmsg=0

for /f "delims=:" %%A in ('"findstr /L /S /I /N /c:"go_7+." "*.mes""') do (

 set str=%%~nA
 REM echo !str!
 set str=!str:m_=!
 REM echo !str!
 FOR /F "tokens=* delims=0" %%B IN ("!str!") DO SET Var=%%B
 IF "!Var!"=="" SET Var=0
 REM echo VAR=!Var! lastmsg=!lastmsg!
 if !Var! gtr !lastmsg!  (
    echo %%~nA -- has 7Plus
    type %%A >> "%output_path%\to_decode.txt"
 )
 set newlastmsg=!Var!
)

echo Last message we've seen = %newlastmsg% 
echo %newlastmsg% > %output_path%\lastmsg.txt


if not exist %output_path%\to_decode.txt (
  echo No 7plus messages found since we last ran.
  goto end
)

cd %output_path%\decoded
..\7plus -y -x ..\to_decode.txt

for %%f in (*.p01) do (
 ..\7plus %%~nf
 
 if errorlevel 0 (
    echo Decode OK! Removing parts...
    del %%~nf.p*
  )
)

echo Removing tmp file... 
del %output_path%\to_decode.txt
   
:end

echo.
echo Finished!
echo.
