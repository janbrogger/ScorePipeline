USE HolbergAnon
DROP TABLE #TR1
DROP TABLE #TR2

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [RecordingId]      
      ,[FileName]
      ,[FilePath]	  
	  ,Convert(Bit, Case When LEFT(FilePath,9) = N'\\MONITOR' OR LEFT(FilePath,5) = N'\\EEG' OR LEFT(FilePath,3) = N'C:\' OR LEFT(FilePath,10) = N'\\PORTABEL' OR LEFT(FilePath,14) = N'\\KNF-PORTABEL' OR LEN(FilePath)=0 Then 1 Else 0 End) As IsInvalidLocalFile
	  ,TRY_CONVERT(int, REVERSE(LEFT(REVERSE(FilePath), PATINDEX(N'%[0-9][0-9][0-9][0-9][0-9]%', REVERSE(FilePath))+4))) AS NervusFileIndex	  	  
  INTO #TR1
  FROM [HolbergAnon].[dbo].[Recording]
    --ORDER BY IsInvalidLocalFile DESC

--Trial-run the select query

SELECT [RecordingId]      
      ,[FileName]
      ,[FilePath]	  
	  ,NervusFileIndex	  	
	  ,Case 
			When NervusFileIndex >= 60001 AND NervusFileIndex<999999 Then '\\hbemta-nevrofil01.knf.local\Rutine\workarea\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 55001 AND NervusFileIndex<60000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv4\55001-60000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 50001 AND NervusFileIndex<55000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv3\50001-55000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 45001 AND NervusFileIndex<50001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv2\45001-50000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 40001 AND NervusFileIndex<45001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\40001-45000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 35001 AND NervusFileIndex<40001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\35001-40000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 30001 AND NervusFileIndex<35001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\30001-35000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 25001 AND NervusFileIndex<30001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\25001-30000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 20001 AND NervusFileIndex<25001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\20001-25000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 15001 AND NervusFileIndex<20001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\15001-20000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 10001 AND NervusFileIndex<15001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\10001-15000\'+CONVERT(nvarchar, NervusFileIndex)
			When NervusFileIndex >= 00001 AND NervusFileIndex<10001  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\0-10000\'+CONVERT(nvarchar, NervusFileIndex)			 
			ELSE '' 
		End AS NewPath  
INTO #TR2
FROM #TR1
WHERE IsInvalidLocalFile=0 

SELECT * FROM #TR2

UPDATE Recording 
   SET Recording.FilePath = #TR2.NewPath   
   FROM Recording 
   INNER JOIN #TR2 ON Recording.RecordingId = #TR2.RecordingId
GO



SELECT * FROM Recording 