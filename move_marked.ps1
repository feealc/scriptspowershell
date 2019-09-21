param([bool]$showPressEnter)

function GetFolderName
{
	param([string]$episodio)

	$folderName = ""

	# =============================================================================================
	# removendo a extensao
	$episodioClean = $episodio -replace ".rmvb","" -replace ".mp4",""
	# Write-Host "GetFolderName - ep : [$episodio] ep clean [$episodioClean]"

	# =============================================================================================
	# quebrar pelos espacos
	$epSplitSpaces = $episodioClean -split " "
	# foreach($e in $epSplitSpaces)
	# {
	# 	Write-Host "e : [$e]"
	# }
	
	# =============================================================================================
	# montar o nome da serie
	$posicaoFinal = $epSplitSpaces.Count - 1
	if ($epSplitSpaces[$posicaoFinal] -contains "Finale)")
	{
		$posicaoFinal -= 2
	}
	$nomeSerie = ""
	for ($i = 0; $i -lt $posicaoFinal; $i++)
	{
		# Write-Host "i [$i] epSplitSpaces ["$epSplitSpaces[$i]"]"
		$nomeSerie += $epSplitSpaces[$i] + " "
	}
	$nomeSerie = $nomeSerie.Trim()
	$folderName += $nomeSerie
	# Write-Host "nome [$nomeSerie]"

	# =============================================================================================
	# pegando a temporada
	$epTemporada = $epSplitSpaces[$posicaoFinal]
	$tempSplit = $epTemporada -split "x"
	# Write-Host "temp [$epTemporada] count [$($tempSplit.Count)]"
	if ($tempSplit.Count -lt 2)
	{
		return ""
	}
	$folderName += " - $($tempSplit[0]) Temporada"
	# foreach($t in $tempSplit)
	# {
	# 	Write-Host "t [$t]"
	# }

	# =============================================================================================

	# Write-Host "folderName [$folderName]"
	return $folderName
}

# =================================================================================================
# INICIO
# =================================================================================================

# contador
# $totalArquivoTorrent = 0
# $totalFound = 0
# $totalNotFound = 0

# [string[]]$arrayDirNames = @()

# Pastas
$pathMarcados = "D:\Series2\MARCADOS"
# $pathTorretDownloaded = "D:\Torrent"

$files = [IO.Directory]::GetFiles($pathMarcados, "*.rmvb")
$files += [IO.Directory]::GetFiles($pathMarcados, "*.mp4")
$dirs = [IO.Directory]::GetDirectories($pathMarcados, "*Temporada")

# foreach($dir in $dirs)
# {
# 	Write-Host "dir : " $dir
# }

foreach($file in $files)
{
	# Write-Host "file : " $file
	$fileNameSplit = $file -split "\\"
	$fileName = $fileNameSplit[($fileNameSplit).length - 1]
	# Write-Host "file name : [$fileName]"

	# montar o nome da pasta pra ver se existe
	$folderName = GetFolderName $fileName
	# Write-Host "nome da pasta : [$folderName]"

	# procurando a pasta
	$foundDir = $false
	$fullDir = ""
	foreach($dir in $dirs)
	{
		$dirSplit = $dir -split "\\"
		$dirNome = $dirSplit[$dirSplit.Count - 1]
		# Write-Host "Diretorio [$($dir)] Nome Diretorio [$($dirNome)] folderName [$($folderName)]"
		if ($dirNome -eq $folderName)
		{
			$foundDir = $true
			$fullDir = $dir
			break
		}
	}

	if ($foundDir)
	{
		# Write-Host "Diretorio [$($dir)] folderName [$($folderName)]"
		Write-Host "Movendo [$($pathMarcados)\$($fileName)] para [$($fullDir)]"
		Move-Item -Path $pathMarcados\$fileName -Destination $fullDir
	}
	else
	{
		Write-Host "Diretorio nao encontrado para [$($fileName)]"
	}
	
	# Write-Host ""
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
