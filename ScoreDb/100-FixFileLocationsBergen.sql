USE HolbergAnon3
GO
IF OBJECT_ID('tempdb..#TR1') IS NOT NULL DROP TABLE tempdb..#TR1
IF OBJECT_ID('tempdb..#TR2') IS NOT NULL DROP TABLE tempdb..#TR2

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [RecordingId]      
      ,[FileName]
      ,[FilePath]	  
	  ,Convert(Bit, Case When LEFT(FilePath,9) = N'\\MONITOR' 
		OR LEFT(FilePath,5) = N'\\EEG' 
		OR LEFT(FilePath,3) = N'C:\' 
		OR LEFT(FilePath,10) = N'\\PORTABEL' 
		OR LEFT(FilePath,14) = N'\\KNF-PORTABEL' 
		OR LEFT(FilePath,17) = N'\\hbemta-bkbfil01' 
		OR LEFT(FilePath,6) = N'\\LTM-' 
		OR LEN(FilePath)=0 
		Then 1 Else 0 End) As IsInvalidLocalFile
	  ,REVERSE(LEFT(REVERSE(FilePath), PATINDEX(N'%[0-9][0-9][0-9][0-9][0-9]\%', REVERSE(FilePath))+4)) AS NervusFileIndex	  	  
  INTO #TR1
  FROM [Recording]    

SELECT * FROM #TR1 WHERE IsInvalidLocalFile=0 ORDER BY NervusFileIndex

SELECT [RecordingId]      
      ,[FileName]
      ,[FilePath]	  
	  ,NervusFileIndex	  	
	  ,Case 
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 65001 AND NervusFileIndex<999999  Then '\\hbemta-nevrofil01.knf.local\Rutine\workarea\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 62501 AND NervusFileIndex<=65000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv5\62501-65000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 60001 AND NervusFileIndex<=62500  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv4\60001-62500\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 55001 AND NervusFileIndex<=60000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv4\55001-60000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 50001 AND NervusFileIndex<=55000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv3\50001-55000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 45001 AND NervusFileIndex<=50000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv2\45001-50000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 40001 AND NervusFileIndex<=45000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\40001-45000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 35001 AND NervusFileIndex<=40000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\35001-40000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 30001 AND NervusFileIndex<=35000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\30001-35000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 25001 AND NervusFileIndex<=30000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\25001-30000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 20001 AND NervusFileIndex<=25000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\20001-25000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 15001 AND NervusFileIndex<=20000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\15001-20000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 10001 AND NervusFileIndex<=15000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\10001-15000\'+CONVERT(nvarchar, NervusFileIndex)
			When IsInvalidLocalFile=0 AND NervusFileIndex >= 00001 AND NervusFileIndex<=10000  Then '\\hbemta-nevrofil01.knf.local\RutineArkiv1\0-10000\'+CONVERT(nvarchar, NervusFileIndex)			 
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