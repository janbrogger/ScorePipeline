USE TaugRutine
SELECT tblStudy.[guidStudyID]  
      ,tblStudy.strNotes    
      ,[strTitle]
      ,[strRequestedBy]
      ,[strStudyNo]
	  ,tblTest.dodtRecordingStartTime
	  ,tblTest.dotsRecordingLength*24*60 AS RecordingMinutes
	  ,eegfiles.strPath	  
	  ,eegfiles.strName
  FROM [TaugRutine].[dbo].[tblStudy]
  INNER JOIN tblStudyTest ON tblStudy.guidStudyID = tblStudyTest.guidStudyID
  INNER JOIN tblTest ON tblStudyTest.guidTestID = tblTest.guidTestID
  INNER JOIN eegfiles ON tblTest.lTestID = eegfiles.lTest_Id
  ORDER BY dodtRecordingStartTime DESC