SELECT SearchResultId, StudyId, EventId, COUNT(*) AS Dup 
FROM ##PivotResult5
GROUP BY SearchResultId, StudyId, EventId HAVING COUNT(*)>1
