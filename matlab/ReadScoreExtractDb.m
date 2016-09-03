function [ scoreData ] = ReadScoreExtractDb( scorePath )
%SetupScoreExtractDb Reads in tab-delimited text file with SCORE extracts

    extractFile = [scorePath, '\ScoreDb\ExtractSharps_NormalAndEpi - dummy.txt'];
    if not(exist(extractFile, 'file'))
        disp(['SCORE extract file not found at:', extractFile]);
    else
        %uileID = fopen(extractFile);
        %scoreData = importData(extractFile);
        DELIMITER = '\t';
        HEADERLINES = 1;        
        % Import the file        
        fileId = fopen(extractFile);
        formatString = '%u\t%s\t%u\t%u\t%u\t%u\t%s\t%s\t%u\t%u\t%s\t%u\t%s\t%s\t%s\t%u\t%u\r\n';
%         PatientId
%         DateOfBirth
%         GenderId
%         StudyId
%         DescriptionId
%         RecordingId
%         FilePath
%         FileName
%         EventCodingId
%         EventCodeId
%         Name
%         EventId
%         StartDateTime
%         Duration
%         EndDateTime      
%         IsEpileptiform
%         IsNonEpiSharp
        scoreData = textscan(fileId,formatString,'headerLines', HEADERLINES, 'Delimiter',DELIMITER);
        fields = {'PatientId','DateOfBirth','GenderId','StudyId','DescriptionId','RecordingId','FilePath','FileName','EventCodingId','EventCodeId','Name','EventId','StartDateTime','Duration','EndDateTime','IsEpileptiform','IsNonEpiSharp'};
        fclose(fileId);
        lines = cellfun('length',scoreData(1));
        scoreData = cell2struct(scoreData, fields, 2);
    end
end
