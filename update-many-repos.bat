set git="C:\Program Files (x86)\SmartGit\git\bin\git"
cd c:\Midlertidig_Lagring\eeglab
%git% pull
cd c:\Midlertidig_Lagring\fieldtrip
%git% pull
cd c:\Midlertidig_Lagring\ScorePipeline
%git% pull
cd c:\Midlertidig_Lagring\epileptiform.git
%git% pull
cd c:\Midlertidig_Lagring\ctap
%git% pull
cd C:\Midlertidig_Lagring\AanestadArt2QEEG
%git% pull	
cd C:\Midlertidig_Lagring\ScoreDescriptive
%git% pull	
cd C:\Midlertidig_Lagring\ScorePipeline
call update-fieldtrip-in-eeglab.bat
pause