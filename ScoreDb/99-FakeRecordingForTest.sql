USE [HolbergAnon]
GO

UPDATE [dbo].[Recording]
   SET [FileName] = N'Patient5_EEG246_t1.e'
      ,[FilePath] = N'C:\LocalDB\Workarea\45198\'      



declare @FromDate datetime = '2012-12-07 09:33:39'
declare @ToDate datetime = '2012-12-07 09:53:39'


UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), @FromDate)
UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(second, rand(checksum(newid()))*(1+1199), @FromDate)
GO


