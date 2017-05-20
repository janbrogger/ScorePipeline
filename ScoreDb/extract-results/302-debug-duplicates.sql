IF OBJECT_ID('tempdb..#duplicates') IS NOT NULL DROP TABLE #duplicates

SELECT COUNT(SearchResultEventId) AS NumberOfDuplicates, SearchResultEventId 
INTO #duplicates
FROM ##PivotResult4
GROUP BY SearchResultEventId
HAVING COUNT(SearchResultEventId)>1
ORDER BY COUNT(SearchResultEventId) DESC



SELECT #duplicates.*, ##PivotResult4.* FROM #duplicates
INNER JOIN ##PivotResult4 ON #duplicates.SearchResultEventId = ##PivotResult4.SearchResultEventId
WHERE #duplicates.NumberOfDuplicates > 1
ORDER BY #duplicates.NumberOfDuplicates DESC