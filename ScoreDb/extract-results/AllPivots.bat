SET SERVER=.
SET DATABASE=HolbergAnon
sqlcmd -S %SERVER% -d %DATABASE% -i 200-Pivot-base.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 201-Pivot1-Annotations.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 202-Pivot2-UserAnnotations.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 203-Pivot3-IndicationsForEeg.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 204-Pivot3-Medications.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 205-Pivot4-Referrer.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 206-Pivot5-Diagnose.sql -E -r1 1> NUL
sqlcmd -S %SERVER% -d %DATABASE% -i 207-DiagnosticSignificance.sql -E -r1 1> NUL
pause
