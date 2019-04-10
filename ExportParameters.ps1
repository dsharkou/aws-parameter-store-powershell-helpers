param(
    [Parameter(Mandatory=$false)]
	$sourcePrefixPath,
    [Parameter(Mandatory=$true)]
	$outputFilePath = "C:\temp\parameters_export.json"
)

Import-Module AWSPowerShell;

Write-Host "Using sourcePrefixPath $sourcePrefixPath"
Write-Host "Using outputFilePath $outputFilePath"

try
{
	Write-Host "Getting configuration from AWS Parameter Store"
	
	$parameters = New-Object System.Collections.ArrayList

    Get-SSMParametersByPath -Path $sourcePrefixPath -WithDecryption $true -Recursive $true | ForEach-Object {
		#Out-String -InputObject $_ 
		$nameWithoutPrefix = $_.Name.Replace($sourcePrefixPath, "");
        
		$parameterHash = [ordered]@{
			PathWithoutPrefix = $nameWithoutPrefix
			Type = $_.Type.Value
			Value = $_.Value
		}

		$parameter = New-Object PSObject -Property $parameterHash
		$parameters.Add($parameter)
    };

	# Create directory if it's not created
	$directodyPath = Split-Path -parent $outputFilePath
	if (-not (Test-Path -Path $directodyPath))
	{
		New-Item -Path $directodyPath -ItemType "directory"
	}

	# Write result to file
	$parameters | ConvertTo-Json | Out-File $outputFilePath
		
    Write-Host "Parameters exported successfully";
}
catch {
    Write-Host "Unable to export parameters"
    Write-Host $_.Exception.Message;
    Write-Host $_.Exception;
}
