param([bool]$showPressEnter)

function CheckReadOnlyFlag
{
	# $readOnlyFlag=(Get-ChildItem -Path $file).IsReadOnly
	$readOnlyFlag=(Get-ChildItem -Path $args[0]).IsReadOnly
	Write-Host "Flag ReadOnly : $readOnlyFlag"
}

function ChangeReadOnlyFlag
{
	param([bool]$Flag)
	Set-ItemProperty -Path $file -Name IsReadOnly -Value $Flag
}

# =================================================================================================
# INICIO
# =================================================================================================

# contador
$totalDiretorio = 0
$totalArquivoAlterado = 0
$totalDiretorioSemArquivo = 0

# array diretorios sem legenda
# $arrayDiretorioSemArquivo = @()
# Write-Host "len array : " $arrayDiretorioSemArquivo.length
# $arrayDiretorioSemArquivo.Add("teste 1")
# $arrayDiretorioSemArquivo.Add("teste 2")
# Write-Host "len array : " $arrayDiretorioSemArquivo.length

# Pen Drive
# $pathDir = "F:\#Eu"
# $pathDir = "F:\#Pai"

# Pasta teste
$pathDir = "D:\Torrent"

Write-Host ">>> INICIO"
Write-Host "Diretorio: " $pathDir

$dirs = [IO.Directory]::GetDirectories($pathDir)
foreach($dir in $dirs)
{
	# Write-Host "Diretorio : $dir"
	
	$files = [IO.Directory]::GetFiles($dir, "*.srt")
	$filesLen = ($files).length

	# Write-Host "length : " $filesLen

	if ($filesLen -gt 0)
	{
		foreach($file in $files)
		{
			# Write-Host "Arquivo srt : $file"
			# Write-Host "Alterando encoding : $file"
			# CheckReadOnlyFlag $file
			
			# removendo ReadOnly flag
			# Write-Host "Removendo flag ReadOnly"
			ChangeReadOnlyFlag $false

			# alterando enconding
			$content = get-content -path $file
			$content | out-file $file -encoding utf8

			# setando ReadOnly flag
			# Write-Host "Setando flag ReadOnly"
			ChangeReadOnlyFlag $true

			# contador
			$totalArquivoAlterado += 1
		}

		if ($filesLen -ge 2)
		{
			Write-Host "Mais de um arquivo srt encontrado : " $dir
		}
	}
	else
	{
		Write-Host "Nenhum arquivo srt encontrado : " $dir

		# contador
		$totalDiretorioSemArquivo += 1
	}

	# contador
	$totalDiretorio += 1
}

Write-Host "FIM <<<"

if ($totalDiretorio -eq ($totalArquivoAlterado + $totalDiretorioSemArquivo))
{
	$result = "OK"
}
else
{
	$result = "NOK"
}

Write-Host "`n==================================================`n"
Write-Host "Total diretorios            : " $totalDiretorio
Write-Host "Total arquivos alterados    : " $totalArquivoAlterado
Write-Host "Total diretorio sem arquivo : " $totalDiretorioSemArquivo
# Write-Host ""
Write-Host "Result                      : " $result

# Write-Host "showPressEnter : $showPressEnter"
if ($showPressEnter)
{
	Write-Host "`n"
	Read-Host -Prompt "Press <enter> to continue..."
}
