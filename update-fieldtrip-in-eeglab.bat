@echo off
echo Copies the fileio part of the fieldtrip repository
echo to the plugin part of the EEGLAB repository
xcopy C:\Midlertidig_Lagring\fieldtrip\fileio\*.* C:\Midlertidig_Lagring\eeglab\plugins\Fileio\ /s /Y
echo Done! See above for error messages
pause
