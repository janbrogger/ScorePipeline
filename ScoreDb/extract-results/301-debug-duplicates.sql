--Look for multiple descriptions per study
IF OBJECT_ID('tempdb..#dup') IS NOT NULL DROP TABLE #dup
SELECT DISTINCT StudyId INTO #dup FROM ##PivotBase

SELECT #dup.StudyId, COUNT(Description.DescriptionID) AS DescriptionCount
FROM #dup
JOIN Description ON #dup.StudyId = Description.StudyId
GROUP BY #dup.StudyId
ORDER BY COUNT(Description.DescriptionID) DESC 

