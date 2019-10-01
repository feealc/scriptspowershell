param([bool]$showPressEnter, [bool]$askForPath, [bool]$askForConfirm)

function removeExtensions
{
	param([string]$fileName)
	
	return $fileName -replace ".rmvb","" -replace ".mp4","" -replace ".avi","" -replace ".mkv","" -replace ".srt",""
}

function pressEnter
{
	Write-Host "`n"
	Read-Host -Prompt "Press <enter> to continue..."
}

# =================================================================================================
# INICIO
# =================================================================================================

if ($askForPath)
{
	$pathMainFolder = Read-Host "`nEntre com o diretorio para criar as pastas"
}
else
{
	$pathMainFolder = "C:\Users\ferna\Desktop\PastaTestePS"
	# $pathMainFolder = "F:\#Eu\Castle"
}

if (-not (Test-Path -Path $pathMainFolder -PathType Container))
{
	Write-Host "Diretorio invalido!`n"
	pressEnter
	exit
}

Write-Host "`nDiretorio : $pathMainFolder `n"

if ($askForConfirm)
{
	$result = Read-Host "Deseja continuar? [s/n]"
	# Write-Host "result [$result]"

	if ($result.ToLower() -eq "n")
	{
		Write-Host "`nCancelado!"
		pressEnter
		exit
	}
}

$movieFiles = [IO.Directory]::GetFiles($pathMainFolder, "*.rmvb")
$movieFiles += [IO.Directory]::GetFiles($pathMainFolder, "*.mp4")
$movieFiles += [IO.Directory]::GetFiles($pathMainFolder, "*.avi")
$movieFiles += [IO.Directory]::GetFiles($pathMainFolder, "*.mkv")

$subFiles += [IO.Directory]::GetFiles($pathMainFolder, "*.srt")

$movieFilesCount = $movieFiles.Count
$subFilesCount = $subFiles.Count

if ($movieFilesCount -ne $subFilesCount)
{
	Write-Host "Total dos arquivos de filme [$movieFilesCount] e leganda [$subFilesCount] nao sao iguais."
	pressEnter
	exit
}

For ($i=0; $i -lt $movieFilesCount; $i++)
{
	# Write-Host "==========================="

	$movieTmp = $movieFiles[$i]
	$subTmp = $subFiles[$i]

	$movieSplit = $movieTmp -split "\\"
	$movieName = $movieSplit[($movieSplit).length - 1]
	$movieNameClean = removeExtensions $movieName

	$subSplit = $subTmp -split "\\"
	$subName = $subSplit[($subSplit).length - 1]
	$subNameClean = removeExtensions $subName

	if ($movieNameClean.toLower() -ne $subNameClean.toLower())
	{
		For ($j=0; $j -lt $subFilesCount; $j++)
		{
			$subTmp2 = $subFiles[$j]

			$subSplit2 = $subTmp2 -split "\\"
			$subName2 = $subSplit2[($subSplit2).length - 1]
			$subNameClean2 = removeExtensions $subName2

			if ($movieNameClean.toLower() -eq $subNameClean2.toLower())
			{
				$subTmp = $subTmp2

				$subName = $subName2
				$subNameClean = $subNameClean2

				break
			}
		}
	}

	Write-Host "Criando pasta [$($movieNameClean.toLower())]"
	New-Item -Path $pathMainFolder -Name $movieNameClean.toLower() -ItemType Directory -Force > $null

	$newPathFileName = $pathMainFolder + "\" + $movieNameClean.toLower()

	Write-Host "Movendo [$movieTmp] para [$($newPathFileName)]"
	Move-Item -Path $movieTmp -Destination $newPathFileName
	Write-Host "Movendo [$subTmp] para [$($newPathFileName)]"
	Move-Item -Path $subTmp -Destination $newPathFileName

	# Write-Host "index [$i]"
	# Write-Host "movie [$movieTmp] sub [$subTmp]"
	# Write-Host "movie - file [$movieName] clean [$movieNameClean]"
	# Write-Host "sub - file [$subName] clean [$subNameClean]"
	# Write-Host "folder [($newPathFileName)]"
}

Write-Host "`n`nListando arquivos:`n"

$dirs = [IO.Directory]::GetDirectories($pathMainFolder)

foreach ($dir in $dirs)
{
	Write-Host $dir
	
	$files = [IO.Directory]::GetFiles($dir)

	foreach ($file in $files)
	{
		$fileSplit = $file -split "\\"
		$fileName = $fileSplit[($fileSplit).length - 1]

		Write-Host $fileName
	}
}

if ($showPressEnter)
{
	pressEnter
}
