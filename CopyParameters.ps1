param(
    [Parameter(Mandatory=$true)]
	$sourcePrefixPath,
    [Parameter(Mandatory=$true)]
	$targetPrefixPath
)

Import-Module AWSPowerShell;

Write-Host "Using sourcePrefixPath $sourcePrefixPath"
Write-Host "Using targetPrefixPath $targetPrefixPath"

try
{
	Write-Host "Getting configuration from AWS Parameter Store"
	
    Get-SSMParametersByPath -Path $sourcePrefixPath -WithDecryption $true -Recursive $true | ForEach-Object {
		#Out-String -InputObject $_ 
        $newPath = $_.Name.Replace($sourcePrefixPath, $targetPrefixPath);
        Write-Host "Copy parameter $($_.Name) to $newPath"
		Write-SSMParameter -Name $newPath -Type $_.Type -Value $_.Value -Force
    };
	
    Write-Host "Parameters copied successfully";
}
catch {
    Write-Host "Unable to copy parameters"
    Write-Host $_.Exception.Message;
    Write-Host $_.Exception;
}
