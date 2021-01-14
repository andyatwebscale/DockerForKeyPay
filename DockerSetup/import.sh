#!/bin/bash

echo "Waiting 30 seconds for SQL Server to initialise"
sleep 30s

echo "Create login payroll"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "USE Master"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "CREATE LOGIN payroll WITH PASSWORD = 'payroll', DEFAULT_DATABASE=Master, CHECK_POLICY=OFF, CHECK_EXPIRATION=OFF"

echo "Make payroll login a sysadmin"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "exec sp_addsrvrolemember 'payroll', 'sysadmin'"

sleep 3s

echo "Restoring Payroll_Common"
sleep 5s
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "	
	DECLARE @DatabaseFilename VARCHAR(128) 	
	DECLARE @DataName VARCHAR(128) 
	DECLARE @LogsName VARCHAR(128) 
	DECLARE @NewDataLocation VARCHAR(128) 
	DECLARE @NewLogsLocation VARCHAR(128) 
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000)) 
	
	SET @DatabaseFilename = '/backups/Payroll_Common.bak' 	
		
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ') 
	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/Payroll_Common.mdf'); 
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/Payroll_Common_log.ldf'); 
	SET @DataName =(select LogicalName from @filelist where [Type] ='D') 
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L') 
	DELETE FROM @filelist
	
	RESTORE DATABASE Payroll_Common FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation

	ALTER DATABASE Payroll_Common SET RECOVERY SIMPLE	
"

echo "Restoring Payroll_Shard4"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "	
	USE Master
	DECLARE @DataName VARCHAR(128)	
	DECLARE @DatabaseFilename VARCHAR(128)	
	DECLARE @LogsName VARCHAR(128)
	DECLARE @NewDataLocation VARCHAR(128)
	DECLARE @NewLogsLocation VARCHAR(128)		
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000))
		
	SET @DatabaseFilename = '/backups/Payroll_Shard4.bak'	
		
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ')
	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/Payroll_Shard4.mdf');
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/Payroll_Shard4_log.ldf');
	SET @DataName =(select LogicalName from @filelist where [Type] ='D')
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L')
	DELETE FROM @filelist
	
	RESTORE DATABASE Payroll_Shard4 FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation   

	ALTER DATABASE Payroll_Shard4 SET RECOVERY SIMPLE	
"

echo "Restoring Payroll_Shard5"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	USE Master	
	DECLARE @DatabaseFilename VARCHAR(128)	
	DECLARE @DataName VARCHAR(128)
	DECLARE @LogsName VARCHAR(128)
	DECLARE @NewDataLocation VARCHAR(128)
	DECLARE @NewLogsLocation VARCHAR(128)		
	DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000))
		
	SET @DatabaseFilename = '/backups/Payroll_Shard5.bak'	
		
	INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ')
	SET @NewDataLocation = (SELECT '/var/opt/mssql/data/Payroll_Shard5.mdf');
	SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/Payroll_Shard5_log.ldf');
	SET @DataName =(select LogicalName from @filelist where [Type] ='D')
	SET @LogsName = (select LogicalName from @filelist where [Type] ='L')
	DELETE FROM @filelist
	
	RESTORE DATABASE Payroll_Shard5 FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation

	ALTER DATABASE Payroll_Shard5 SET RECOVERY SIMPLE	
"

echo "Setting up Whitelabel Alias for localhost"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "UPDATE Payroll_Common.dbo.WhiteLabelAlias SET WhiteLabelId = (SELECT Id FROM Payroll_Common.dbo.WhiteLabelShard WHERE HostName='keypay.yourpayroll.co.uk') WHERE HostName='localhost'"
echo "Setting up Whitelabel Alias for keypay.yourpayroll.local (Shard 4)"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "UPDATE Payroll_Common.dbo.WhiteLabelAlias SET WhiteLabelId = (SELECT Id FROM Payroll_Common.dbo.WhiteLabelShard WHERE HostName='keypay.yourpayroll.co.uk') WHERE HostName='keypay.yourpayroll.local'"
echo "Setting up Whitelabel Alias for qbouk.yourpayroll.local (Shard 5)"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "Update WhiteLabelAlias SET HostName = 'qbouk.yourpayroll.local' WHERE Id in (select TOP 1 Id from WhiteLabeLAlias WHERE WhiteLabelId = 326 ORDER BY Id DESC)"
echo "Setting up Whitelabel Alias for keypaynz.yourpayroll.local (NZ region on Shard 4)"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "INSERT INTO WhiteLabelAlias (WhiteLabelId, HostName) VALUES (136, 'keypaynz.yourpayroll.local')"
echo "Setting up Whitelabel Alias for keypaysg.yourpayroll.local (SG region on Shard 4)"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "INSERT INTO WhiteLabelAlias (WhiteLabelId, HostName) VALUES (137, 'keypaysg.yourpayroll.local')"
echo "Setting up Whitelabel Alias for keypayau.yourpayroll.local (AU region on Shard 4)"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "INSERT INTO WhiteLabelAlias (WhiteLabelId, HostName) VALUES (105, 'keypayau.yourpayroll.local')"


echo "Setting up users"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	USE Payroll_Common
	CREATE USER payroll FOR LOGIN payroll	
		
	USE Payroll_Shard4
	CREATE USER payroll FOR LOGIN payroll

	USE Payroll_Shard5
	CREATE USER payroll FOR LOGIN payroll	
"

echo "Clearing transaction logs"
/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q "
	DECLARE @statement NVARCHAR(500);
    
	DECLARE cursor_databases CURSOR
	FOR SELECT 
			'USE [' + d.name + N']' + CHAR(13) + CHAR(10) 
			+ 'DBCC SHRINKFILE (N''' + mf.name + N''' , 1)' 
			+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		FROM 
				sys.master_files mf 
			JOIN sys.databases d 
				ON mf.database_id = d.database_id 
		WHERE d.database_id > 4

	OPEN cursor_databases;

	FETCH NEXT FROM cursor_databases INTO 
		@statement;

	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE sp_executesql @statement

			FETCH NEXT FROM cursor_databases INTO 
				@statement;
		END;

	CLOSE cursor_databases;

	DEALLOCATE cursor_databases;
"
