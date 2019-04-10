param(
    [Parameter(Mandatory=$true)]
	$prefixPath,
    [Parameter(Mandatory=$true)]
	$filePath
)

Import-Module AWSPowerShell;

Write-Host "Using prefixPath $prefixPath"
Write-Host "Using filePath $filePath"

if(!(Test-Path $filePath))
{
	throw "Could not file '$filePath' to import parameters"
}

try
{
	Write-Host "Getting content from file"
	
	$parameters = Get-Content $filePath -Raw | ConvertFrom-Json
	
    $parameters | ForEach-Object {
		#Out-String -InputObject $_ 
		$newPrefix = $prefixPath + $_.PathWithoutPrefix

        Write-Host "Creating parameter $newPrefix"
		Write-SSMParameter -Name $newPrefix -Type $_.Type -Value $_.Value -Force
    };

    Write-Host "Parameters imported successfully";
}
catch {
    Write-Host "Unable to import parameters"
    Write-Host $_.Exception.Message;
    Write-Host $_.Exception;
}
