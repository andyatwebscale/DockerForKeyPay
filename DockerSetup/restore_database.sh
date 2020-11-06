echo '> Restoring ' $1

statements=("","")

statements+="DECLARE @DatabaseName VARCHAR(128) "
statements+="DECLARE @DatabaseFilename VARCHAR(128) "
statements+="SET @DatabaseName = '"$1"' "
statements+="SET @DatabaseFilename = '/backups/@DatabaseName.bak' "
statements+="DECLARE @DataName VARCHAR(128) "
statements+="DECLARE @LogsName VARCHAR(128) "
statements+="DECLARE @NewDataLocation VARCHAR(128) "
statements+="DECLARE @NewLogsLocation VARCHAR(128) "
statements+="DECLARE @filelist TABLE (LogicalName varchar(128),[PhysicalName] varchar(128),[Type] varchar,[FileGroupName] varchar(128),[Size] varchar(128),[MaxSize] varchar(128),[FileId]varchar(128),[CreateLSN]varchar(128),[DropLSN]varchar(128),[UniqueId]varchar(128),[ReadOnlyLSN]varchar(128),[ReadWriteLSN]varchar(128),[BackupSizeInBytes]varchar(128),[SourceBlockSize]varchar(128),[FileGroupId]varchar(128),[LogGroupGUID]varchar(128),[DifferentialBaseLSN]varchar(128),[DifferentialBaseGUID]varchar(128),[IsReadOnly]varchar(128),[IsPresent]varchar(128),[TDEThumbprint]varchar(128),[SnapshotUrl]varchar(2000)) "
statements+="INSERT INTO @filelist EXEC('RESTORE FILELISTONLY FROM DISK=''' + @DatabaseFilename + ''' ') "
statements+="SET @NewDataLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '.mdf'); "
statements+="SET @NewLogsLocation = (SELECT '/var/opt/mssql/data/' + @DatabaseName + '_log.ldf'); "
statements+="SET @DataName =(select LogicalName from @filelist where [Type] ='D') "
statements+="SET @LogsName = (select LogicalName from @filelist where [Type] ='L') "
statements+="RESTORE DATABASE @DatabaseName FROM DISK=@DatabaseFilename WITH MOVE @DataName TO @NewDataLocation, MOVE @LogsName TO @NewLogsLocation "
statements+="ALTER DATABASE @DatabaseName SET RECOVERY SIMPLE "
statements+="DBCC SHRINKFILE (@DatabaseName + '_log', 1) "
statements+="DECLARE @UseStatement VARCHAR(128) "
statements+="SET @UseStatement = (SELECT 'USE ["$1"]') "
statements+="EXEC sp_sqlexec @UseStatement "
statements+="CREATE USER payroll FOR LOGIN payroll"

sql=""

for s in $statements; do
	$sql=$sql+$s
done

echo ">> Executing: " $sql

#/opt/mssql-tools/bin/sqlcmd -U sa -P SaPassword1 -Q $sql
	
