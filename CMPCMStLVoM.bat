@echo off
:: this makes seeing the current state of variables much easier with !variable_name! also i stopped using it for anything
setlocal enabledelayedexpansion
:: Setting variables. btw ASuccess and AFail where attempted solutions to solve a problem (oversight i should have saw) that worked anyway (not for fixing the oversight) so i kept them
set "ASuccess=Passed windows version check [Stage 1/4.1]"
set "AFail=Your OS is too old to run the latest version of MAME"
set "="
set "CI64DOWNDIR=%TMP%\Coreinfo64.exe"
:: this is pretty self-explanitory don't you think?
echo ______________________________________________________________ 
echo ^|                                                            ^|
echo ^|                    W  A  R  N  I  N  G                     ^| 
echo ^|                                                            ^|
echo ^|                                                            ^|
echo ^|    This script downlads some programs neccesary to the     ^|
echo ^|    function of this script if you don't like this you      ^|
echo ^|               can always close the script                  ^|
echo ^|                                                            ^|
echo ^|                        N  O  T  E                          ^|
echo ^|                                                            ^|
echo ^|                                                            ^|
echo ^|    This script is only meant for use with x86 versions     ^|
echo ^|    of windows if you are using windows for ARM this is     ^|
echo ^|                      not for you                           ^|
echo ^|                                                            ^|
echo ^|                                                            ^|
echo ^|                                                            ^|
echo ______________________________________________________________
:: makes the user aknowledge the warning
pause
:: check windows version
for /f "tokens=1-7 delims=[.] " %%A in ('ver') do (
if 10010240 LEQ %%D%%E%%F (echo %ASuccess%) else (echo %AFail% & EXIT /B 1))
:: The Magic Sauceⓒ also this makes myDownloadJob and downloads using it
bitsadmin /create myDownloadJob && bitsadmin /transfer myDownloadJob https://github.com/maiovaio/does-my-pc-maybe-support-the-latest-mame/raw/refs/heads/main/Coreinfo64.exe %CI64DOWNDIR% & bitsadmin /complete myDownloadJob && echo Downloaded Coreinfo64 successfully [Stage 2/4.1]
:: Mark as much as i love that you made this, why? (I'm referncing the question i asked below in the filename)
%TMP%\Coreinfo64.exe -f > %TMP%\coreinfo64.txt && echo Made temporary TXT with CPU specifications [Stage 2.1/4.1]
:: checking if the cpu supports the full x86-64-v2 specification
find "*" %TMP%\coreinfo64.txt | find "CX16" && find "*" %TMP%\coreinfo64.txt | findstr "\<SSE3\>" && find "*" %TMP%\coreinfo64.txt | find "SSE4.1" && find "*" %TMP%\coreinfo64.txt | find "SSE4.2" && find "*" %TMP%\coreinfo64.txt | find "POPCNT" && find "*" %TMP%\coreinfo64.txt | find "LAHF-SAHF" && find "*" %TMP%\coreinfo64.txt | find "SSSE3" && echo Passed x86-64 level check [Stage 2.2/4] || (echo Your CPU doesn't support the full x86-64-v2 specification 
EXIT /B 1)
:: checks the os architecture
if defined ProgramFiles(x86) (echo Checked OS Architecture [Stage 3/4.1]) ELSE (
echo Checked OS Architecture & find "*" %TMP%\coreinfo64.txt | find "X64" && echo Upgrade your pc to a 64-bit version of windows to run the latest version of MAME maybe & EXIT /B 1 || echo Your PC is 32-bit and will not run the latest mame version & EXIT /B 1
)
:: making temp txt for RAM check
systeminfo > %TMP%\sysinfo.txt && echo Made temporary txt with RAM info [Stage 4/4.1]
:: checking RAM amount
for /f "tokens=1-7 delims=,MB " %%A in ('findstr /C:"Total Physical Memory" %TMP%\sysinfo.txt') do (if 3650 LEQ %%D%%E (echo Passed RAM check [Stage 4.1/4.1]) ELSE (echo You have too little RAM to run MAME & EXIT /B 1))
echo Cleaning up
del %TMP%\sysinfo.txt
del %TMP%\coreinfo64.txt
del %TMP%\coreinfo64.exe
