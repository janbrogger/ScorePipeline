@echo off
echo Copies the fileio part of the fieldtrip repository
echo to the plugin part of the EEGLAB repository
xcopy C:\Users\Jan\Documents\GitHub\fieldtrip\fileio\*.* C:\Users\Jan\Documents\GitHub\eeglab\plugins\Fileio161116\ /s /Y
echo Done! See above for error messages
pause
