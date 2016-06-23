 addpath J:\nicoletsdk\MFiles
 NicSt = NicOpen('J:\ScorePipeline\janbrogger.e'); %Opens the file Test.e 

%Get One Segment
iSegment = 1;        					%One based so first segment of data
vChannels = [];  					%Get Channels 2 and 5

DataOneSegment = NicGetFullData(NicSt, iSegment, vChannels);

%Get Time Chunk
StartTime = NicSt.vSegmentStartTime(1);                %Get the starttime of the file

SecondsIntoFile = 65;
[ierr,ReadStartTime] = calllib('mat1','RecSecToDate',SecondsIntoFile, zeros(1));

SecondsToRead = 8;
data = NicGetData(NicSt, ReadStartTime, SecondsToRead, vChannels);  
NicPlot(NicSt, data, SecondsToRead);

NicClose();                    
