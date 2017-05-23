USE master
BACKUP DATABASE Holberg 
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\Holberg_20160620.bak'
GO

RESTORE DATABASE HolbergAnon FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\Holberg_20160620.bak' 
WITH MOVE 'Holberg_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data\HolbergAnon.mdf',
MOVE 'Holberg_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data\HolbergAnon.ldf'
GO

USE HolbergAnon
GO

UPDATE [HolbergAnon].[dbo].[PatientDetails]
   SET       
       [LastName] = CONVERT(varchar(255), NEWID())
      ,[FirstName] = CONVERT(varchar(255), NEWID())
      ,[DateOfBirth] = DATEFROMPARTS(YEAR(DateOfBirth),MONTH(DateOfBirth),1)
      ,[IdentityString] = CONVERT(varchar(255), NEWID())
      ,[Notes] = N''
      ,[Address] = CONVERT(varchar(255), NEWID())
      ,[PostalCode] = CONVERT(varchar(255), NEWID())
      ,[PostalCodeName] = CONVERT(varchar(255), NEWID())
      ,[PhoneNumber] = CONVERT(varchar(255), NEWID())
      ,[MotherName] = CONVERT(varchar(255), NEWID())       
GO

BACKUP DATABASE HolbergAnon 
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\HolbergAnon_20160620.bak'
GO

ALTER DATABASE HolbergAnon SET SINGLE_USER WITH ROLLBACK IMMEDIATE
EXEC master.dbo.sp_detach_db @dbname = N'HolbergAnon'

