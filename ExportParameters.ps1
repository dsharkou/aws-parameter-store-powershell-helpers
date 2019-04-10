param(
    [Parameter(Mandatory=$true)]
	$prefixPath,
    [Parameter(Mandatory=$true)]
	$filePath
)

Import-Module AWSPowerShell;

Write-Host "Using prefixPath $prefixPath"
Write-Host "Using filePath $filePath"

try
{
	Write-Host "Getting configuration from AWS Parameter Store"
	
	$parameters = New-Object System.Collections.ArrayList

    Get-SSMParametersByPath -Path $prefixPath -WithDecryption $true -Recursive $true | ForEach-Object {
		#Out-String -InputObject $_ 
		$pathWithoutPrefix = $_.Name.Replace($prefixPath, "");
        
		$parameterHash = [ordered]@{
			PathWithoutPrefix = $pathWithoutPrefix
			Type = $_.Type.Value
			Value = $_.Value
		}

		$parameter = New-Object PSObject -Property $parameterHash
		$parameters.Add($parameter)
    };

	# Create directory if it's not created
	$directodyPath = Split-Path -parent $filePath
	if (-not (Test-Path -Path $directodyPath))
	{
		New-Item -Path $directodyPath -ItemType "directory"
	}

	# Write result to file
	$parameters | ConvertTo-Json | Out-File $filePath
		
    Write-Host "Parameters exported successfully";
}
catch {
    Write-Host "Unable to export parameters"
    Write-Host $_.Exception.Message;
    Write-Host $_.Exception;
}
