@echo off
echo Copies the fileio part of the fieldtrip repository
echo to the plugin part of the EEGLAB repository
xcopy J:\fieldtrip\fileio\*.* J:\eeglab\plugins\Fileio161116\ /s /Y
echo Done! See above for error messages
pause
