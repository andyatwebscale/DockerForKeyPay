#!/bin/bash

echo "Waiting for SQL Server to initialise"
sleep 15s

echo "Create login payroll"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "USE Master"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "CREATE LOGIN payroll WITH PASSWORD = 'payroll', DEFAULT_DATABASE=Master, CHECK_POLICY=OFF, CHECK_EXPIRATION=OFF"

echo "Make payroll login a sysadmin"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "exec sp_addsrvrolemember 'payroll', 'sysadmin'"

echo "Restoring Payroll_Common"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	DECLARE @DatabaseName VARCHAR(128)	
	DECLARE @DatabaseFilename VARCHAR(128)
	SET @DatabaseName = 'Payroll_Common'	
	SET @DatabaseFilename = '/backups/Payroll_Common.bak'
	
	DECLARE @UseStatement VARCHAR(128)
	SET @UseStatement = (SELECT 'USE [' + @DatabaseName + ']')
	
	DECLARE @DataName VARCHAR(128)
	DECLARE @LogsName VARCHAR(128)
	DECLARE @NewDataLocation VARCHAR(128)
	DECLARE @NewLogsLocation VARCHAR(128)
		
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000))
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ')

	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '.mdf');
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '_log.ldf');
	SET @DataName =(select LogicalName from @filelist where [Type] ='D')
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L')
	RESTORE DATABASE @DatabaseName FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation

	EXEC sp_sqlexec @UseStatement	
	CREATE USER payroll FOR LOGIN payroll
"

echo "Setting up Whitelabel Alias for localhost"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "UPDATE Payroll_Common.dbo.WhiteLabelAlias SET WhiteLabelId = (SELECT Id FROM Payroll_Common.dbo.WhiteLabelShard WHERE HostName='keypay.yourpayroll.co.uk') WHERE HostName='localhost'"

echo "Restoring Payroll_Shard4"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	DECLARE @DatabaseName VARCHAR(128)	
	DECLARE @DatabaseFilename VARCHAR(128)
	SET @DatabaseName = 'Payroll_Shard4'	
	SET @DatabaseFilename = '/backups/Payroll_Shard4.bak'
	
	DECLARE @UseStatement VARCHAR(128)
	SET @UseStatement = (SELECT 'USE [' + @DatabaseName + ']')
	
	DECLARE @DataName VARCHAR(128)
	DECLARE @LogsName VARCHAR(128)
	DECLARE @NewDataLocation VARCHAR(128)
	DECLARE @NewLogsLocation VARCHAR(128)
		
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000))
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ')

	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '.mdf');
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '_log.ldf');
	SET @DataName =(select LogicalName from @filelist where [Type] ='D')
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L')
	RESTORE DATABASE @DatabaseName FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation

	EXEC sp_sqlexec @UseStatement	
	CREATE USER payroll FOR LOGIN payroll
"

echo "Restoring Payroll_Shard5"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	DECLARE @DatabaseName VARCHAR(128)	
	DECLARE @DatabaseFilename VARCHAR(128)
	SET @DatabaseName = 'Payroll_Shard5'	
	SET @DatabaseFilename = '/backups/Payroll_Shard5.bak'
	
	DECLARE @UseStatement VARCHAR(128)
	SET @UseStatement = (SELECT 'USE [' + @DatabaseName + ']')
	
	DECLARE @DataName VARCHAR(128)
	DECLARE @LogsName VARCHAR(128)
	DECLARE @NewDataLocation VARCHAR(128)
	DECLARE @NewLogsLocation VARCHAR(128)
		
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000))
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ')

	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '.mdf');
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '_log.ldf');
	SET @DataName =(select LogicalName from @filelist where [Type] ='D')
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L')
	RESTORE DATABASE @DatabaseName FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation

	EXEC sp_sqlexec @UseStatement	
	CREATE USER payroll FOR LOGIN payroll
"