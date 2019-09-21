param([bool]$showPressEnter)

# =================================================================================================
# INICIO
# =================================================================================================

# contador
$totalArquivoTorrent = 0
$totalFound = 0
$totalNotFound = 0

[string[]]$arrayDirNames = @()

# Pastas
$pathTorretFile = "C:\Users\ferna\Downloads"
$pathTorretDownloaded = "D:\Torrent"

$files = [IO.Directory]::GetFiles($pathTorretFile, "*.torrent")
$dirs = [IO.Directory]::GetDirectories($pathTorretDownloaded)

foreach($dir in $dirs)
{
	# Write-Host "Nome do diretorio : $dir"
	$dirNameSplit = $dir -split "\\"
	$dirName = $dirNameSplit[2] # posicao 3 - nome do diretorio

	# $arrayDirNames.Add($dirName)
	$arrayDirNames += $dirName
	# Write-Host "dir : $dirName"
}

foreach($file in $files)
{
	# Write-Host "Nome do arquivo : $file"
	$fileNameSplit = $file -split "\\" -replace ".torrent",""
	$fileName = $fileNameSplit[4] # posicao 5 - nome do arquivo
	# Write-Host "file : $fileName"

	$found = $false
	foreach($d in $arrayDirNames)
	{
		if($d -eq $fileName)
		# if($d.Equals($fileName))
		{
			# Write-Host "FOUND!! - fileName [$fileName] d [$d]"
			$found = $true
			break
		}
	}

	if($found -eq $true)
	{
		Write-Host "FOUND!! - fileName [$fileName]"
		$totalFound++
	}
	else
	{
		Write-Host "NOT FOUND!! - fileName [$fileName]"
		# Write-Host $file
		Remove-Item $file
		$totalNotFound++
	}

	$totalArquivoTorrent++
}

if ($totalArquivoTorrent -eq ($totalFound + $totalNotFound))
{
	$result = "OK"
}
else
{
	$result = "NOK"
}

Write-Host "`n==================================================`n"
Write-Host "Total arquivos torrent  : " $totalArquivoTorrent
Write-Host "Total found             : " $totalFound
Write-Host "Total not found         : " $totalNotFound
# Write-Host ""
Write-Host "Result                  : " $result

# Write-Host "showPressEnter : $showPressEnter"
if ($showPressEnter)
{
	Write-Host "`n"
	Read-Host -Prompt "Press <enter> to continue..."
}
