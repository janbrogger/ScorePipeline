function [ scoreData ] = SetupScoreExtractDb( scorePath )
%SetupScoreExtractDb Reads in tab-delimited text file with SCORE extracts

    extractFile = [scorePath, '\ScoreDb\ExtractSharps_NormalAndEpi.txt'];
    if not(exist(extractFile, 'file'))
        disp(['SCORE extract file not found at:', extractFile]);
    else
        %uileID = fopen(extractFile);
        %scoreData = importData(extractFile);
        DELIMITER = '\t';
        HEADERLINES = 1;        
        % Import the file        
        fileId = fopen(extractFile);
        formatString = '%u\t%s\t%u\t%u\t%u\t%u\t%s\t%s\t%u\t%u\t%s\t%u\t%s\t%s\t%s\r\n';
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
        scoreData = textscan(fileId,formatString,'headerLines', HEADERLINES, 'Delimiter',DELIMITER);
        fields = {'PatientId','DateOfBirth','GenderId','StudyId','DescriptionId','RecordingId','FilePath','FileName','EventCodingId','EventCodeId','Name','EventId','StartDateTime','Duration','EndDateTime'};
        fclose(fileId);
        lines = cellfun('length',scoreData(1));
        scoreData = cell2struct(scoreData, fields, 2);
    end
end
