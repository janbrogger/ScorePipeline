function [ scoreData ] = SetupScoreExtractDb( scorePath )
%SetupScoreExtractDb Reads in tab-delimited text file with SCORE extracts

    extractFile = [scorePath, '..\ScoreDb\ExtractSharps_NormalAndEpi.txt'];
    if not(exist(extractFile, 'file'))
        disp(['SCORE extract file not found at:', extractFile]);
    else
        scoreData = tdfread(extractFile,'\t');
    end
end
