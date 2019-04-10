param(
    [Parameter(Mandatory=$true)]
	$sourcePrefixPath
)

Import-Module AWSPowerShell;

Write-Host "Using sourcePrefixPath $sourcePrefixPath"

try
{
	Write-Host "Getting configuration from AWS Parameter Store"
	
    Get-SSMParametersByPath -Path $sourcePrefixPath -WithDecryption $true -Recursive $true | ForEach-Object {
		#Out-String -InputObject $_ 
        Write-Host "Remove parameter $($_.Name)"
		Remove-SSMParameter -Name $_.Name -Force
    };
    Write-Host "Parameters removed successfully";
}
catch {
    Write-Host "Unable to remove parameters"
    Write-Host $_.Exception.Message;
    Write-Host $_.Exception;
}
