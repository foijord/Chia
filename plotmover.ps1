param (
	[Parameter(Mandatory=$True)][string] $TempDir,
	[Parameter(Mandatory=$True)][string] $DestDir)

$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path = $TempDir
$FileSystemWatcher.EnableRaisingEvents = $true

$Action = {
	$details = $event.SourceEventArgs
	$DestDir = $event.MessageData.DestDir
	$TempDir = $event.MessageData.TempDir

	$message = "Moving {0} to {1}" -f $details.FullPath, $DestDir
	Write-Host $message -ForegroundColor Yellow -NoNewline
	Move-Item -Path $details.FullPath -Destination $DestDir
	Write-Host "  Done" -ForegroundColor Green
}

$Directories = new-object psobject -property @{
	DestDir = $DestDir
	TempDir = $TempDir
}

$objectEventArgs = @{
	Action = $Action
	EventName = 'Renamed'
	MessageData = $Directories
	SourceIdentifier = 'FSRename'
	InputObject = $FileSystemWatcher
}

$MoveJob = Register-ObjectEvent @objectEventArgs
Write-Host "Finished plots will be moved from $TempDir to $DestDir"

try {
	Wait-Event -SourceIdentifier FSRename
}
finally {
	Unregister-Event -SourceIdentifier FSRename
	Remove-Job $MoveJob
	$FileSystemWatcher.EnableRaisingEvents = $false
	$FileSystemWatcher.Dispose()
	Write-Host "Stopped waiting for finished plots..."
}
