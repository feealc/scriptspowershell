param([bool]$showPressEnter)

function removeExtensions
{
	param([string]$fileName)
	
	return $fileName -replace ".rmvb","" -replace ".mp4","" -replace ".avi","" -replace ".mkv","" -replace ".srt",""
}

# =================================================================================================
# INICIO
# =================================================================================================

$pathMainFolder = Read-Host "`nEntre com o diretorio para criar as pastas"
# Write-Host "dir [$pathMainFolder]"

# $pathMainFolder = "C:\Users\ferna\Desktop\PastaTestePS"
# $pathMainFolder = "F:\#Eu\Castle"

if (-not (Test-Path -Path $pathMainFolder -PathType Container))
{
	Write-Host "Diretorio invalido!"
	exit
}

Write-Host "Diretorio : $pathMainFolder"

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
	exit
}

For ($i=0; $i -lt $movieFilesCount; $i++)
{
	Write-Host "==========================="

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
		Write-Host "diff"

		For ($j=0; $j -lt $subFilesCount; $j++)
		{
			$subTmp2 = $subFiles[$j]

			# Write-Host "index j [$j]"

			$subSplit2 = $subTmp2 -split "\\"
			$subName2 = $subSplit2[($subSplit2).length - 1]
			$subNameClean2 = removeExtensions $subName2

			if ($movieNameClean.toLower() -eq $subNameClean2.toLower())
			{
				Write-Host = "Found equal - index [$j]"

				$subTmp = $subTmp2

				$subName = $subName2
				$subNameClean = $subNameClean2

				break
			}
		}
	}

	New-Item -Path $pathMainFolder -Name $movieNameClean.toLower() -ItemType Directory -Force > $null

	$newPathFileName = $pathMainFolder + "\" + $movieNameClean.toLower()

	Move-Item -Path $movieTmp -Destination $newPathFileName
	Move-Item -Path $subTmp -Destination $newPathFileName

	Write-Host "index [$i]"
	Write-Host "movie [$movieTmp] sub [$subTmp]"
	Write-Host "movie - file [$movieName] clean [$movieNameClean]"
	Write-Host "sub - file [$subName] clean [$subNameClean]"
	Write-Host "folder [($newPathFileName)]"
}

# $oRetorno = GetFolderName
# Write-Host "O retorno foi : $oRetorno"

# Write-Host "`n==================================================`n"
# Write-Host "Total arquivos torrent  : " $totalArquivoTorrent
# Write-Host "Total found             : " $totalFound
# Write-Host "Total not found         : " $totalNotFound
# Write-Host ""
# Write-Host "Result                  : " $result

# Write-Host "showPressEnter : $showPressEnter"
if ($showPressEnter)
{
	Write-Host "`n"
	Read-Host -Prompt "Press <enter> to continue..."
}
