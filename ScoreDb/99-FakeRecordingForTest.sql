USE [HolbergAnon]
GO


declare @FromDate1 datetime       = '2013-09-17 12:27:19'
declare @ToDate1 datetime         = '2013-09-17 12:51:19'
declare @FileName1 nvarchar(99)   = N'Patient2_KNF-PORTABEL_t1.e'
declare @FilePath1 nvarchar(99)   = N'C:\\LocalDB\\Workarea\\45195\\'
UPDATE [dbo].[Recording] SET [FileName] =  @FileName1,[FilePath] = @FilePath1, [Start] = @FromDate1  WHERE RecordingId % 2 = 0
UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate1, @ToDate1)), @FromDate1) WHERE RecordingId % 2 = 0
UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(second, rand(checksum(newid()))*(1+1199), @FromDate1) WHERE RecordingId % 2 = 0


declare @FromDate2 datetime        = '2013-08-29 11:59:43'
declare @ToDate2 datetime          = '2013-08-29 12:19:19'
declare @FileName2 nvarchar(99)    = N'Patient9_EEG226_t1.e'
declare @FilePath2 nvarchar(99)    = N'C:\\LocalDB\\Workarea\\45190\\'
UPDATE [dbo].[Recording] SET [FileName] =  @FileName2,[FilePath] = @FilePath2, [Start] = @FromDate2  WHERE RecordingId % 2 = 1
UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate2, @ToDate2)), @FromDate2) WHERE RecordingId % 2 = 1
UPDATE [dbo].[Event] SET [StartDateTime] = dateadd(second, rand(checksum(newid()))*(1+1199), @FromDate2) WHERE RecordingId % 2 = 1



GO


